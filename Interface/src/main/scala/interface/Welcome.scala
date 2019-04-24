package interface

import scalafx.scene.layout.Pane
import scalafx.scene.text.Text
import scalafx.geometry.Insets
import scalafx.scene.control.Label
import scalafx.scene.layout.VBox
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

object Welcome extends Pane {

  prefHeight = 900
  prefWidth = 1500 - Menu.menuWidth

  children = new VBox {
        padding = Insets(20)
        children = Seq(
          new Text {
            prefWidth <== Welcome.width
            text = "Welcome!"
            style = "-fx-font-size: 48pt"
            fill = White
          },
          new Label {
            padding = Insets(40)
            text = "Lorem ipsum dolor sit amet blablabla I really would like to write a maximum of text here but I do not have any imagination please help me."
            wrapText = true
            prefWidth <== Welcome.width
            style = "-fx-font-size: 16pt"
            textFill = White
          }
        )
      }
}
