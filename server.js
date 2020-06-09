console.info("Program Started");
var expess = require("express");
var bodyParser = require("body-parser");
var fs = require("fs");
var app = expess();

const path = require('path')
const {spawn} = require('child_process')

function runScript(parameter){
    return spawn('python', [
       "-u",
       path.join(__dirname, 'prediction.py'),
      parameter
    ]);
 }
 
 function toUTF8Array(str) {
    let utf8 = [];
    for (let i = 0; i < str.length; i++) {
        let charcode = str.charCodeAt(i);
        if (charcode < 0x80) utf8.push(charcode);
        else if (charcode < 0x800) {
            utf8.push(0xc0 | (charcode >> 6),
                      0x80 | (charcode & 0x3f));
        }
        else if (charcode < 0xd800 || charcode >= 0xe000) {
            utf8.push(0xe0 | (charcode >> 12),
                      0x80 | ((charcode>>6) & 0x3f),
                      0x80 | (charcode & 0x3f));
        }
        // surrogate pair
        else {
            i++;
            // UTF-16 encodes 0x10000-0x10FFFF by
            // subtracting 0x10000 and splitting the
            // 20 bits of 0x0-0xFFFFF into two halves
            charcode = 0x10000 + (((charcode & 0x3ff)<<10)
                      | (str.charCodeAt(i) & 0x3ff));
            utf8.push(0xf0 | (charcode >>18),
                      0x80 | ((charcode>>12) & 0x3f),
                      0x80 | ((charcode>>6) & 0x3f),
                      0x80 | (charcode & 0x3f));
        }
    }
    return utf8;
}

app.use(bodyParser.urlencoded({ extended: true, limit: "10mb" }));
app.post("/landmark", function(req, res){
  console.info("geldi");
  var name = req.body.name;
  var img = req.body.image;
  var realFile = Buffer.from(img,"base64");
  fs.writeFile(`./savedimages/${name}`, realFile, function(err) {
      if(err)
         console.log(err);
      console.info("basarili");
   });

   const subprocess = runScript(name);

   var largeDataSet = [];
 
   subprocess.stdout.on('data', (data) => {
       console.log(`data:${data}`);
       largeDataSet.push(data);
       console.info(largeDataSet.toString())
   });
   subprocess.stderr.on('data', (data) => {
       console.log(`error:${data}`);
   });
   subprocess.stderr.on('close', () => {
       console.log("Closed");
       a = String("aaaa");
       var v = largeDataSet.join("");
       var c = v.split("##");
       var filename = c[0];
       console.info();
       console.info(c[0]);
       console.info();
       a = toUTF8Array(v);
       var options = {
        headers: {
            'x-timestamp': Date.now(),
            'x-sent': true,
            'name': a,
            'origin':'stackoverflow'
        }
      };
      res.sendFile(`pathToLandmarksDirectory\\landmarks\\${filename}.jpg`, options);
   });

 });

app.listen(3000); //port number