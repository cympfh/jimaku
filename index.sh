#!/bin/bash

if [ ! -f ~/.kirara ]; then
    echo "Not found ~/.kirara"
    exit 1
fi
source ~/.kirara

cat <<EOM
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Speech-to-Text</title>
  <script>

    var str_prev = localStorage.getItem('str_prev') || '';
    var str = localStorage.getItem('str') || '';
    var str_interim = '';

    function update() {
      document.getElementById('jimaku_prev').innerHTML = str_prev;
      document.getElementById('jimaku').innerHTML = str;
      document.getElementById('jimaku_interim').innerHTML = str_interim;
    }
    setInterval(update, 500);

    function echo(text) {
      var style = 'color: #884488; font-weight: bold; font-size: 20px; \
      text-shadow: #dddddd 2px 0px,  #dddddd -2px 0px, #dddddd 0px -2px, \
      #dddddd 0px 2px, #dddddd 2px 2px, #dddddd -2px 2px, #dddddd 2px -2px, \
      #dddddd -2px -2px, #dddddd 1px 2px,  #dddddd -1px 2px, #dddddd 1px -2px, \
      #dddddd -1px -2px, #dddddd 2px 1px,  #dddddd -2px 1px, #dddddd 2px -1px, \
      #dddddd -2px -1px;';
      console.log('%c%s', style, text);

      str_prev = str;
      str = text;
      str_interim = '';
      localStorage.setItem('str_prev', str_prev);
      localStorage.setItem('str', str);

      var xhr = new XMLHttpRequest();
      xhr.open('POST', 'http://s.cympfh.cc/live/cympfh');
      xhr.setRequestHeader('X-KEY', '${IK_KEY}');
      xhr.send(text);
    }

    var SpeechRecognition = webkitSpeechRecognition || SpeechRecognition;
    var recognition = new SpeechRecognition();
    recognition.lang = 'ja-JP'; // 'en-US'
    recognition.interimResults = true;
    recognition.continuous = true;

    recognition.onsoundstart = () => {
      console.log('[I] Listening...')
    };

    recognition.onnomatch = () => {
      console.log('[I] NoMatch (try again)');
    };

    recognition.onerror = (err) => {
      console.log('[I] Error', err);
      location.reload();
    };

    recognition.onsoundend = () => {
      console.log('[I] End');
      location.reload();
    };

    recognition.onresult = (event) => {
      for (var i = event.resultIndex; i < event.results.length; i++){
        if (event.results[i].isFinal){
          echo(event.results[i][0].transcript);
        } else{
          console.log('[I] Interim:', event.results[i][0].transcript);
          str_interim = event.results[i][0].transcript;
          update();
        }
      }
    };

    recognition.start();
  </script>
<style>
    div#jimaku_prev {
      font-size: 13px;
      color: #884488; font-weight: bold; font-size: 18px;
      text-shadow: #dddddd 2px 0px,  #dddddd -2px 0px, #dddddd 0px -2px,
      #dddddd 0px 2px, #dddddd 2px 2px, #dddddd -2px 2px, #dddddd 2px -2px,
      #dddddd -2px -2px, #dddddd 1px 2px,  #dddddd -1px 2px, #dddddd 1px -2px,
      #dddddd -1px -2px, #dddddd 2px 1px,  #dddddd -2px 1px, #dddddd 2px -1px,
      #dddddd -2px -1px;
    }
    div#jimaku {
      color: #884488; font-weight: bold; font-size: 24px;
      text-shadow: #dddddd 2px 0px,  #dddddd -2px 0px, #dddddd 0px -2px,
      #dddddd 0px 2px, #dddddd 2px 2px, #dddddd -2px 2px, #dddddd 2px -2px,
      #dddddd -2px -2px, #dddddd 1px 2px,  #dddddd -1px 2px, #dddddd 1px -2px,
      #dddddd -1px -2px, #dddddd 2px 1px,  #dddddd -2px 1px, #dddddd 2px -1px,
      #dddddd -2px -1px;
    }
    div#jimaku_interim {
      color: black;
      font-size: 13px;
      font-weight: bold;
      text-shadow: #dddddd 2px 0px,  #dddddd -2px 0px, #dddddd 0px -2px,
      #dddddd 0px 2px, #dddddd 2px 2px, #dddddd -2px 2px, #dddddd 2px -2px,
      #dddddd -2px -2px, #dddddd 1px 2px,  #dddddd -1px 2px, #dddddd 1px -2px,
      #dddddd -1px -2px, #dddddd 2px 1px,  #dddddd -2px 1px, #dddddd 2px -1px,
      #dddddd -2px -1px;
    }
</style>
</head>
<body>
  <div id="jimaku_prev"></div>
  <div id="jimaku"></div>
  <div id="jimaku_interim"></div>
</body>
</html>
EOM