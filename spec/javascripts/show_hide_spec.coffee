//= require jquery
//= require jasmine-jquery
//= require show_hide

fixtureHtml = (inputId, disabledRadioChecked, enabledRadioChecked) ->
  disabledChecked = if disabledRadioChecked then 'checked="checked"' else ""
  enabledChecked = if enabledRadioChecked then 'checked="checked"' else ""

  $("""
  <body>
  <div>
    <fieldset>
      <label for="defence_request_appropriate_adult">Appropriate adult</label>
      <label for="defence_request_appropriate_adult_true">
        <input name="defence_request[appropriate_adult]" value="true" #{ enabledChecked } id="defence_request_appropriate_adult_true" type="radio">
        Yes
      </label>
      <label for="defence_request_appropriate_adult_false">
        <input name="defence_request[appropriate_adult]" value="false" #{ disabledChecked } id="defence_request_appropriate_adult_false" type="radio">
        No
      </label>
    </fieldset>
  </div>

  <div>
    <label for="defence_request_appropriate_adult_reason">Reason for appropriate adult</label>
    <textarea data-show-when="defence_request_appropriate_adult_true" name="defence_request[appropriate_adult_reason]" id="#{ inputId }"></textarea>
  </div>
  </body>
  """)

fixtureSetup = (element, inputId, context) ->
  $(document.body).append(element)

  context.otherRadio = $("#defence_request_appropriate_adult_false").eq(0)
  context.showRadio = $("#defence_request_appropriate_adult_true").eq(0)
  context.inputToShow = $( "[data-show-when]" ).eq(0)
  context.disableChecker = new window.ShowHide( context.inputToShow )

describe "ShowHide", ->
  element = null

  afterEach ->
    element.remove()
    element = null

  describe "when no radio checked", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, false, false)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "hides input", ->
        expect( @inputToShow ).toBeHidden()

    describe "show radio is checked", ->
      it "shows input", ->
        @showRadio.trigger("click")
        expect( @inputToShow ).not.toBeHidden()

    describe "other radio is checked", ->
      it "leaves input hidden", ->
        @otherRadio.trigger("click")
        expect( @inputToShow ).toBeHidden()

    describe "other radio is checked then show radio is checked", ->
      it "shows input", ->
        @otherRadio.trigger("click")
        @showRadio.trigger("click")
        expect( @inputToShow ).not.toBeHidden()

  describe "when other radio checked on load", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, true, false)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "hides input", ->
        expect( @inputToShow ).toBeHidden()

  describe "when show radio checked on load", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, false, true)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "leaves input shown", ->
        expect( @inputToShow ).not.toBeHidden()
