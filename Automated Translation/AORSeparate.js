// This was used to separate a list of words between those that were English and those that were Indonesian

var googleTranslate = require('google-translate')(apiKey);
var Sync = require('sync');
var _ = require('underscore');
var sleep = require('sleep');
var CoffeeScript = require("coffee-script");
CoffeeScript.register()
var LineReaderSync = require("line-reader-sync")

var lines =[];
var reader = new LineReaderSync('originalFrom10602.csv');
do{
  var line = reader.readline()
  if (line !== null) {
    lines.push(line);
  }
} while(line !== null);

var lineCount = -1;
Sync(function () {
    lines.forEach(function(line) {
      lineCount++;
      //if(lineCount> 10){
      //  return false;
      //}
      if (lineCount == 0) {
        console.log("order\tfilename\tartist\tcountry\ten\tid");
        return true;//skip first line
      }
      var parts = line.split(",");
      var words = parts[4].split("|");
      words = words.map(function (s) {
        return s.trim()
      });

      var detections = googleTranslate.detectLanguage.sync(null, words);
      // that returns an object, instead of an array, if there is only one word. This ensures we have an array:
      detections = [].concat(detections);

      var warning=(lineCount == parts[0])? "" : "line skipped?";
      if (lineCount != parts[0]) {
        lineCount = parseInt(parts[0]);
      }

      console.log(parts[0] + "\t" + parts[1] + "\t" +parts[2] + "\t" + parts[3] + "\t" + getStringOfLanguage(detections, "en") + "\t" + getStringOfNotLanguage(detections, "en")+warning);

      //google translate max is 100 per second
      sleep.usleep(20000); //20,000 should be 50/second    (100,000 micro seconds is 10/th of a second)
    })
});

function getStringOfLanguage(detections, languageId){
  var words = detections.map(function (d) {
    if (d.language == languageId) return d.originalText
  })
  return _.compact(words).join(",");
}

//originally, we just called getStringOfLanguage("id") to get the indonesian ones, but notice a high rate of false negatives. So now
//we use this and say "if it isn't English, assume it's Indonesian"
function getStringOfNotLanguage(detections, languageId){
  return _.compact(detections.map(function(d){if(d.language != languageId) return d.originalText})).join(",");
}
