require 'capybara/rspec'
require 'selenium-webdriver'
require 'rspec-steps'

Capybara.register_driver(:selenium_chrome) do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

if ENV['SELENIUM_CHROME'] 
  Selenium::WebDriver::Chrome.driver_path = "/usr/lib/chromium-browser/chromedriver"
  Capybara.default_driver = :selenium_chrome
else
  Capybara.default_driver = :selenium
end

module SaveAndOpenOnFail
  def instance_eval(&block)
    super(&block)
  rescue Object => ex
    wrapper = ex.exception("#{ex.message}\nLast view at: file://#{save_page}")
    wrapper.set_backtrace(ex.backtrace)
    raise wrapper
  end
end

module HandyXPaths
  class Builder <  XPath::Expression::Self
    include XPath::HTML
    include RSpec::Core::Extensions::InstanceEvalWithArgs
  end

  module Attrs
    def attrs(hash)
      all(*hash.map do |name, value|
        XPath.attr(name) == value
      end)
    end

    def all(*expressions)
      expressions.inject(current) do |chain, expression|
        chain.where(expression)
      end
    end
  end

  def make_xpath(*args, &block)
    xpath = Builder.new
    unless block.nil?
      xpath = xpath.instance_eval_with_args(*args, &block)
    end
    return xpath
  end
end

module XPath
  include HandyXPaths::Attrs
  extend HandyXPaths::Attrs
end

class XPath::Expression
  include HandyXPaths::Attrs
end

module CKEditorTools
  def fill_in_ckeditor(id, options = {})
  raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)    
    if options[:with]    
      browser = page.driver.browser
      browser.execute_script("CKEDITOR.instances['#{id}'].setData('#{options[:with]}');")
    end
  end
end


module Capybara
  module RSpecMatchers
    class HaveVisibleMatcher < HaveMatcher
      def matches?(actual)
        super and @actual.send(:"find_#{name}", *arguments).visible?
      end

      def does_not_match?(actual)
        super or !( @actual.send(:"find_#{name}", *arguments).visible? )
      end 
    end

    def have_visible_link(locator, options={})
      HaveVisibleMatcher.new(:link, locator, options)
    end
  end
end
