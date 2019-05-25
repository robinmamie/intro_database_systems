scalaVersion := "2.12.8"

name := "airbnb-11"
organization := "ch.epfl.cs322"
version := "1.0"

libraryDependencies += "org.typelevel" %% "cats-core" % "1.6.0"
libraryDependencies += "org.scalafx" %% "scalafx" % "8.0.144-R12"

javaOptions += "-Dfile.encoding=UTF8"
javacOptions ++= Seq("-encoding", "UTF-8")
//javaOptions += "-Dprism.verbose=true"
//fork := true
