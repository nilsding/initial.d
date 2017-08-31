#!/usr/bin/env rdmd -J.

// initial.d - a Toyota AE86 for your terminals
// (c) 2017 nilsding

import std.algorithm;
import std.array;
import std.datetime : dur;
import std.stdio : write, writef, writeln;
import std.string : splitLines;
import core.thread : Thread;

version (FreeBSD)
{
  import core.sys.posix.sys.ioctl : ioctl, winsize;
  enum TIOCGWINSZ = 0x40087468;
}
else
{
   import core.sys.posix.sys.ioctl : ioctl, TIOCGWINSZ, winsize;
}
import core.sys.posix.unistd : STDOUT_FILENO;

immutable string ae86 = import("ae86.txt");
immutable int width = ae86.splitLines.map!(x => x.length).array.maxElement;
immutable int height = ae86.splitLines.length;

struct TerminalSize
{
  int width;
  int height;
}
TerminalSize termSize = TerminalSize(80, 25);

void main()
{
  termSize = getTerminalSize;

  // make space for the car
  for (auto i = 0; i < height + 1; i++)
  {
    writeln;
  }

  for (int i = -width; i < termSize.width; i++)
  {
    drawCar(i);
    Thread.sleep(dur!("msecs")(10));
    clearCar(i);
  }

  moveToTop;
  writeln("\033[A:-)");
}

/// Gets the current size of the terminal.
TerminalSize getTerminalSize()
{
  winsize w;
  ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
  return TerminalSize(w.ws_col, w.ws_row);
}

/// Moves the cursor up `height` lines.
void moveToTop()
{
  writef("\033[%dA", height);
}

/// Moves the x position of the cursor to `x`
void moveToX(uint x)
{
  writef("\033[%dC", x);
}

/// Prints the string `str` starting at x position `startX`.  If the string is
/// longer than the terminal width, it gets trimmed.
void lineAt(string str, uint startX)
{
  auto x = startX;
  if (startX > 1) moveToX(startX);
  foreach (c; str)
  {
    if (x > 0 && x < termSize.width) write(c);
    x++;
  }
  writeln;
}

/// Draws the car at position `x`
void drawCar(uint x)
{
  moveToTop;
  foreach (str; ae86.splitLines)
  {
    str.lineAt(x);
  }
}

// Clears the first two characters at position `x`
void clearCar(uint x)
{
  moveToTop;
  for (auto i = 0; i < height; i++)
  {
    "  ".lineAt(x);
  }
}

