%w(string/natcmp kernel/ergo).each { |facets_core_ext| require "facets/#{ facets_core_ext }" }


class NilClass

  # Compliments Kernel#ergo.
  #
  #   "a".ergo{ |o| o.upcase } #=> "A"
  #   nil.ergo{ |o| o.bar } #=> nil
  #
  # CREDIT: Daniel DeLorme

  def ergo
    $_ergo ||= Functor.new{ nil }
    $_ergo unless block_given?
  end

end

