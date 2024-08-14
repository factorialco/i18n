require 'test_helper'

class I18nBackendNormalizeTest < I18n::TestCase
  def setup
    super
    I18n.normalize_locale = true
    I18n.backend = I18n::Backend::Simple.new
    I18n.load_path = [locales_dir + '/en.yml']
  end

  test "simple backend translate even with normalize_locale enabled" do
    store_translations :en, available: { "foo" => "Yes", "bar" => "No" }
    assert_equal "Yes", I18n.t("available.foo")
    assert_equal "No", I18n.t("available.bar")

    # Retore the default
    I18n.normalize_locale = false
  end

  test "normalizes the locale before translate" do
    store_translations :en, available: { "foo" => "Yes", "bar" => "No" }
    store_translations :"en-US", available: { "foo" => "Foo", "bar" => "Bar" }

    assert_equal I18n.t("available.foo", locale: 'en-us'), "Foo"
    assert_equal I18n.t("available.bar", locale: :'en-US'), "Bar"

    I18n.with_locale('en-us') do
      assert_equal I18n.t("available.foo"), "Foo"
      assert_equal I18n.t("available.bar"), "Bar"
    end

    # Retore the default
    I18n.normalize_locale = false
  end
end
