package interface

import scalafx.application.JFXApp
import scalafx.application.JFXApp.PrimaryStage
import scalafx.geometry.Insets
import scalafx.scene.Scene
import scalafx.scene.effect.DropShadow
import scalafx.scene.layout.BorderPane
//import scalafx.scene.layout.HBox
import scalafx.scene.paint.Color._
import scalafx.scene.paint.{Stops, LinearGradient}
import scalafx.scene.text.Text


object Airbnb extends JFXApp {


  val appTitle  = "AirBnB, Group 11"
  val appHeight = 900
  val appWidth  = 1500

  stage = new PrimaryStage {
    title = appTitle
    height = appHeight
    width = appWidth
    resizable = false
    scene = new Scene {
        fill = Black
      content = new BorderPane {
        left = Menu
        center = Center
      }
    }
  }
}
