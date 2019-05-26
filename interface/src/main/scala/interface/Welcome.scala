package interface

import scalafx.scene.layout.{HBox, Pane}
import scalafx.scene.text.Text
import scalafx.geometry.Insets
import scalafx.scene.control.{Label, TextField}
import scalafx.scene.layout.VBox
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

import tools.Parser

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
            text = Parser.getString("welcome.txt")
            wrapText = true
            prefWidth <== Welcome.width
            style = "-fx-font-size: 16pt"
            textFill = White
          },
          new HBox {
            spacing = 40
            children = Seq(
              new Text {
                prefWidth = 800
                text = s"Results to fetch (-1 means fetch everything at once):"
                style = "-fx-font-size: 14pt"
                fill = White
              },
              new TextField {
                text <==> GlobalBean.requests
              }
            )
          }
        )
      }
}
