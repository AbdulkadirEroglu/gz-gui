/*
 * Copyright (C) 2018 Open Source Robotics Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
*/
import QtGraphicalEffects 1.0
import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import RenderWindow 1.0

Rectangle {
  Layout.minimumWidth: 200
  Layout.minimumHeight: 200
  anchors.fill: parent
  color: "transparent"

  function makeViewportAncestorsTransparent(item) {
    var current = item
    while (current !== undefined && current !== null) {
      if (current.color !== undefined)
        current.color = "transparent"

      if (current.objectName !== undefined &&
          current.objectName.toString().indexOf("split_item_") === 0) {
        break
      }

      current = current.parent
    }
  }

  /**
   * Get mouse position on 3D widget
   */
  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    visible: MinimalScene.loadingError.length == 0
    onEntered: {
      MinimalScene.OnFocusWindow()
    }
    onPositionChanged: {
      MinimalScene.OnHovered(mouseArea.mouseX, mouseArea.mouseY);
    }
  }

  RenderWindow {
    id: renderWindow
    objectName: "rw"
    anchors.fill: parent
    visible: MinimalScene.loadingError.length == 0
  }


  onParentChanged: {
    if (undefined === parent)
      return;

      width = Qt.binding(function() {return parent.parent.width})
      height = Qt.binding(function() {return parent.parent.height})

      makeViewportAncestorsTransparent(parent)
  }

  DropArea {
  anchors.fill: renderWindow

  onDropped: {
    MinimalScene.OnDropped(drop.text, drag.x, drag.y)
  }

  Label {
    anchors.fill: parent
    anchors.margins: 10
    text: MinimalScene.loadingError
    visible: (MinimalScene.loadingError.length > 0);
    wrapMode: Text.WordWrap
  }
}
}
