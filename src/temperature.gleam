import gleam/float
import gleam/int
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

fn fahrenheit_to_celcius(fahrenheit: Float) -> Float {
  { fahrenheit -. 32.0 } *. 5.0 /. 9.0
}

pub fn celcius_to_fahrenheit(celcius: Float) -> Float {
  celcius *. 9.0 /. 5.0 +. 32.0
}

fn string_to_float(number: String) -> Result(Float, Nil) {
  case int.parse(number) {
    Ok(i) -> Ok(int.to_float(i))
    Error(_) ->
      case float.parse(number) {
        Ok(i) -> Ok(i)
        Error(_) -> Error(Nil)
      }
  }
}

type Model {
  Model(fahrenheit: String, celcius: String)
}

type Msg {
  UserChangedFarenheit(String)
  UserChangedCelcius(String)
}

fn init(_args) -> Model {
  Model(fahrenheit: "", celcius: "")
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedFarenheit(value) -> {
      case string_to_float(value) {
        Ok(fahrenheit) -> {
          Model(
            fahrenheit: value,
            celcius: fahrenheit_to_celcius(fahrenheit) |> float.to_string(),
          )
        }
        Error(_) -> Model(..model, fahrenheit: value)
      }
    }

    UserChangedCelcius(value) -> {
      case string_to_float(value) {
        Ok(celcius) -> {
          Model(
            celcius: value,
            fahrenheit: celcius_to_fahrenheit(celcius) |> float.to_string(),
          )
        }
        Error(_) -> Model(..model, celcius: value)
      }
    }
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "min-h-screen flex items-center justify-center bg-gray-100",
      ),
    ],
    [
      html.div(
        [
          attribute.class(
            "bg-white shadow-lg rounded-xl p-8 flex flex-col items-center w-80",
          ),
        ],
        [
          html.h2([attribute.class("text-2xl font-medium mb-6")], [
            html.text("Fahrenheit to Celsius"),
          ]),
          html.div([attribute.class("w-full flex flex-col gap-4")], [
            html.div([attribute.class("flex flex-col")], [
              html.label(
                [
                  attribute.class("text-sm font-medium mb-1"),
                  attribute.for("fahrenheit"),
                ],
                [html.text(" Fahrenheit ")],
              ),
              html.input([
                attribute.placeholder("Enter °F"),
                attribute.class(
                  "border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400",
                ),
                attribute.id("fahrenheit"),
                attribute.value(model.fahrenheit),
                event.on_input(UserChangedFarenheit),
              ]),
            ]),
            html.div([attribute.class("flex flex-col")], [
              html.label(
                [
                  attribute.class("text-sm font-medium mb-1"),
                  attribute.for("celsius"),
                ],
                [html.text(" Celsius ")],
              ),
              html.input([
                attribute.placeholder("°C"),
                attribute.class(
                  "border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400",
                ),
                attribute.type_("text"),
                attribute.id("celsius"),
                attribute.value(model.celcius),
                event.on_input(UserChangedCelcius),
              ]),
            ]),
          ]),
        ],
      ),
    ],
  )
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}
