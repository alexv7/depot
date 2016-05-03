# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:change", ->
  $('.store .entry > img').click ->
    $(this).parent().find(':submit').click()



#     In this case, the first thing we want to do is to define a function that executes
# on page load. That’s what the first line of this script does: it defines a function
# using the -> operator and passes it to a function named on, which associates
# the function with two events: ready and page:change. ready is the event that fires
# if people navigate to your page from outside of your site, and page:change is the
# event that Turbolinks4 fires if people navigate to your page from within your
# site. Associating the script to both makes sure you are covered either way.
#
# The second line finds all images that are immediate children of elements that
# are defined with class="entry", which themselves are descendants of an element
# with class="store". This last part is important because, just like with stylesheets,
# Rails will by default combine all JavaScripts into a single resource. For each
# image found, which could be zero when run against other pages in our
# application, a function is defined that is associated with the click event for
# that image.
#
# The third and final line processes that click event. It starts with the element
# on which the event occurred, namely, this. It then proceeds to find the parent
# element, which will be the div that specifies class="entry". Within that element
# we find the submit button, and we proceed to click it.
#
# Of course, you could have done all of this in JavaScript directly, but that
# would have required five more sets of parentheses, two sets of braces, and
# overall about 50 percent more characters.
