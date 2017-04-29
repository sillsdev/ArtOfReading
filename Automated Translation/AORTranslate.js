/*
  testing
   node AORTranslate --input aorInProgress.txt --start 1 --lines 2 --lang fr

    This script doesn't add ids to the column headers, so do that yourself, before calling this.

    The following is what I used to do the actual translation. It had to be re-run each time the google translate api
    decided it needed a break. Which is fine because this script saves occasionally, and also goes through looking for things that need to
    be translated, so it can be re-run as many times as you want until there's nothing to do.

    node AORTranslate-compiled.js --input  inprogress.txt --lang hi --output inprogress.txt --start 1 --lines 20000

    This reads in file with lines of tab-delimited data. The only column we care about is the one containing a
    comma-delimited list of English words. This script hands those to Google Translate, then outputs the line
    again but now with the last column being the translated list. Thus, it can be called repeatedly with
    different languages.
 */

var googleTranslate = require('google-translate')('AIzaSyA0jyouJn8k4NYqc6XupJ1-Q7hFpAADEgU');

var CoffeeScript = require("coffee-script");
CoffeeScript.register();
var LineReaderSync = require("line-reader-sync");
var _ = require('underscore');

var argv = require('yargs')
    .usage('Usage: --input InputFile --lang targetISOCode --lines [lines before stopping] --output [OutputFile]')
    .default('lines',99999)
    .demand(['input', 'lang'])
    .argv;
var targetLanguageId = argv.lang;

var RateLimiter = require('limiter').RateLimiter;
// //google translate limits us to 100 requests per second requests per second.
var googleTranslateRateLimiter = new RateLimiter(150, 'second');

// We read all the lines into an array ahead of time because that lets the Sync() thing work, keeping all the Google API calls in order.
// It gave errors if there was line reading going on
let lines =[];
var reader = new LineReaderSync(argv.input);
do{
  var line = reader.readline();
  if (line !== null) {
    lines.push(line.trim());
  }
} while(line !== null);

lines = _.compact(lines); //throw out empty lines

// Now read the header row to find the English and the column we want to output to
var headings = lines[0].split("\t");
var englishColumn = headings.indexOf("en");

//either reuse an existing column if it has the lang id as its heading
var targetLanguageColumn = headings.indexOf(targetLanguageId);
// add the column at the end
if (targetLanguageColumn == -1) {
  targetLanguageColumn = headings.length;
}

// Go through each line, pushing translation back into the line
//let maxImagesToTranslate = Math.min(parseInt(argv.lines), lines.length -1 ); // -1  because we don't count the header

let start = Math.max(parseInt(argv.start), 1);
let end = Math.min(start + parseInt(argv.lines), lines.length - 1);
let numberOfCallsPending = end - start;
let countSinceLastOutput = 0;
for(let i = start; i<= end; i++) {
  let columns = lines[i].split("\t").map(s =>s.trim());
  let englishWords = columns[englishColumn].split(",").map(s =>s.trim());

  //do we already have a translation?
  if(columns.length > targetLanguageColumn && columns[targetLanguageColumn].length>0){
    numberOfCallsPending--; //bug: we'll get no output if this is the very last line
  }
  else {
    googleTranslateRateLimiter.removeTokens(englishWords.length, function () {
      googleTranslate.translate(englishWords, "en", targetLanguageId, function (err, translations) {
        if (typeof err === 'string' || err instanceof String) {
          throw err;
        }
        translations = [].concat(translations); // This ensures we have an array, even if there is only one word

        var translatedWords = translations.map(t => t.translatedText);
        var translatedList = _.compact(translatedWords).join(","); //the _.compact here gets rid of undefined's

        while (columns.length <= (targetLanguageColumn-2)) { // this minus 2 is surely a bug
          columns.push("\t"); // add missing column so that when we push, it goes to the correct column
        }
        if (columns.length <= targetLanguageColumn) {
          columns.push(translatedList); // we need to add it
        }
        else { // we're just updating it
          columns[targetLanguageColumn] = translatedList;
        }
        lines[i] = columns.join("\t");
        numberOfCallsPending--;
        countSinceLastOutput++;

        if (argv.output !== undefined && numberOfCallsPending % 100 === 0) {
          process.stdout.write(".");
        }
        if (numberOfCallsPending <= 0) {
          // Output all the lines
          if (argv.output !== undefined) {
            writeResults(argv.output, lines);
          } else {
            console.log(lines.join('\n'));
          }
          process.exit();
        }
        else if(countSinceLastOutput > 499){  // we do die sometimes, so this keeps us from having to start from scratch
          countSinceLastOutput = 0;
          console.log("Writing checkpoint");
          writeResults(argv.output, lines);
        }
      })
    })
  }
}

function writeResults(filename, lines){
    require("fs").writeFileSync(argv.output, lines.join('\n'));
}
