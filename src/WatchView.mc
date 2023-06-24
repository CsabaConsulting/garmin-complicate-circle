using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Timer as Timer;
using Toybox.Complications as Complications;

enum {
  SCREEN_SHAPE_CIRC = 0x000001,
  SCREEN_SHAPE_SEMICIRC = 0x000002,
  SCREEN_SHAPE_RECT = 0x000003,
  SCREEN_SHAPE_SEMI_OCTAGON = 0x000004
}

public class WatchView extends Ui.WatchFace {

  // globals for devices width and height
  var dw = 0;
  var dh = 0;

  function initialize() {
   Ui.WatchFace.initialize();
  }

  function onLayout(dc) {

    // w,h of canvas
    dw = dc.getWidth();
    dh = dc.getHeight();

    // define the global bounding boxes
    defineBoundingBoxes(dc);

  }

  function onUpdate(dc) {

    // clear the screen
    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    dc.clear();

    // grab time objects
    var clockTime = Sys.getClockTime();

    // define time, day, month variables
    var hours = clockTime.hour;
    var minutes = clockTime.min < 10 ? "0" + clockTime.min : clockTime.min;
    var seconds = clockTime.sec < 10 ? "0" + clockTime.sec : clockTime.sec;
    var font = Gfx.FONT_SYSTEM_NUMBER_MEDIUM;
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    dc.drawText(
      dw / 2,
      dh / 2 - (dc.getFontHeight(font) / 2),
      font, hours.toString() + ":" + minutes.toString() + ":" + seconds.toString(),
      Gfx.TEXT_JUSTIFY_CENTER
    );

    // draw bounding boxes (debug)
    drawBoundingBoxes(dc);

  }

  function onShow() {
  }

  function onHide() {
  }

  function onExitSleep() {
  }

  function onEnterSleep() {
  }

  function defineBoundingBoxes(dc) {

    // "bounds" format is an array as follows [ x, y, r ]
    //  x,y = center of circle
    //  r = radius

    var largeRadius = dw / 5;
    var smallRadius = dw / 8;
    var smallTopY = dh * 8.75 / 32;
    var smallLeftX = dw * 6 / 32;
    var smallRightX = dw * 26 / 32;
    var smallBottomY = dh * 23 / 32;

    boundingBoxes = [
      {
        "label" => "Batt",
        "bounds" => [smallLeftX, smallTopY, smallRadius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_BATTERY
      },
      {
        "label" => "Date",
        "bounds" => [dw / 2, dh * 6.5 / 32, largeRadius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_DATE
      },
      {
        "label" => "BBat",
        "bounds" => [smallRightX, smallTopY, smallRadius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_BODY_BATTERY
      },
      {
        "label" => "SSet",
        "bounds" => [smallLeftX, smallBottomY, smallRadius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_SUNRISE
      },
      {
        "label" => "Temp",
        "bounds" => [dw / 2, dh * 25.5 / 32, largeRadius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE
      },
      {
        "label" => "Rise",
        "bounds" => [smallRightX, smallBottomY, smallRadius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_SUNSET
      }
    ];

  }

  // callback that updates the complication value
  function updateComplication(complication) {

    var thisComplication = Complications.getComplication(complication);
    var thisType = thisComplication.getType();

    for (var i = 0; i < boundingBoxes.size(); i++) {

      if (thisType == boundingBoxes[i]["complicationId"]) {
        boundingBoxes[i]["value"] = thisComplication.value;
        boundingBoxes[i]["label"] = thisComplication.shortLabel;
      }

    }

  }

  // debug by drawing bounding boxes and labels
  function drawBoundingBoxes(dc) {

    dc.setPenWidth(1);

    for (var i = 0; i < boundingBoxes.size(); i++){

      var x = boundingBoxes[i]["bounds"][0];
      var y = boundingBoxes[i]["bounds"][1];
      var r = boundingBoxes[i]["bounds"][2];

      // draw a circle
      dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_DK_RED);
      dc.drawCircle(x, y, r);

      // draw the complication label and value
      var value = boundingBoxes[i]["value"];
      var label = boundingBoxes[i]["label"];
      var font = r < dw / 6 ? Gfx.FONT_SYSTEM_XTINY : Gfx.FONT_SYSTEM_SMALL;

      dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      dc.drawText(x, y - (dc.getFontHeight(font)), font, label.toString(), Gfx.TEXT_JUSTIFY_CENTER);
      dc.drawText(x, y, font, value.toString(), Gfx.TEXT_JUSTIFY_CENTER);

    }

  }


}
