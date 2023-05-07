String formatTime(int time, bool pad)
{
  return (pad) ? 
  ("${(time / 60).floor()}:${(time % 60).toString().padLeft(2,'0')}") : 
  (time > 59) ? ("${(time / 60).floor()}:${(time % 60).toString().padLeft(2,'0')}") : (time.toString());
}