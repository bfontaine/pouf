# -*- coding: UTF-8 -*-

module PoufTestsUtils
  def override_ruby_platform v
    @original_rplatform = RUBY_PLATFORM unless @original_rplatform

    oldstderr, $stderr = $stderr, StringIO.new
    Object.send(:const_set, 'RUBY_PLATFORM', v)
    $stderr = oldstderr
  end

  def reset_ruby_platform
    override_ruby_platform @original_rplatform
  end
end
