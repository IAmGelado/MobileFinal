String getTimeToString(int time) {
  var seconds = 0;
  var minutes = 0;
  var hours = 0;

  seconds = time % 60;
  hours = time ~/3600;
  minutes = (time - (hours * 3600))  ~/ 60;

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}

String getStringToTime(String time) {
  var seconds = int.parse(time.substring(3, 5));
  var minutes = int.parse(time.substring(0, 2));
  var milliseconds = int.parse(time.substring(6, 8));

  var totalMilliseconds = ((minutes * 60 * 1000) + (seconds * 1000) + milliseconds);
  return totalMilliseconds.toString();
}