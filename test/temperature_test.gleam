// import birdie
import birdie
import gleeunit
import gleeunit/should
import lustre/element

// import lustre/element
import temperature

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn float_to_string_valid_float_test() {
  temperature.string_to_float("12.3")
  |> should.equal(Ok(12.3))
}

pub fn float_to_string_valid_int_test() {
  temperature.string_to_float("12")
  |> should.equal(Ok(12.0))
}

pub fn float_to_string_invalid_float_test() {
  temperature.string_to_float("12.0b")
  |> should.equal(Error(temperature.TemperatureInvalidFormat("12.0b")))
}

pub fn init_sets_defaults_test() {
  temperature.init(Nil)
  |> should.equal(temperature.Model(fahrenheit: Ok(32.0), celcius: Ok(0.0)))
}

pub fn user_changed_fahrenheit_test() {
  let model = temperature.Model(fahrenheit: Ok(0.0), celcius: Ok(32.0))

  temperature.update(model, temperature.UserChangedFarenheit("32.0"))
  |> should.equal(temperature.Model(fahrenheit: Ok(32.0), celcius: Ok(0.0)))
}

pub fn user_changed_celcius_test() {
  let model = temperature.Model(fahrenheit: Ok(0.0), celcius: Ok(32.0))

  temperature.update(model, temperature.UserChangedCelcius("32.0"))
  |> should.equal(temperature.Model(fahrenheit: Ok(89.6), celcius: Ok(32.0)))
}

pub fn invalid_fahrenheit_does_not_change_celcius_value_test() {
  let model = temperature.Model(fahrenheit: Ok(0.0), celcius: Ok(32.0))

  temperature.update(model, temperature.UserChangedFarenheit("32.0ab"))
  |> should.equal(temperature.Model(
    fahrenheit: Error(temperature.TemperatureInvalidFormat("32.0ab")),
    celcius: Ok(32.0),
  ))
}

pub fn update_fahrenheit_updates_celcius_test() {
  let model = temperature.Model(fahrenheit: Ok(0.0), celcius: Ok(32.0))

  temperature.update(model, temperature.UserChangedFarenheit("32.0"))
  |> temperature.view()
  |> element.to_readable_string()
  |> birdie.snap(title: "Updating fahrenheit value updates Celcius value")
}
