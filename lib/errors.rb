module UdaciListErrors
  class InvalidItemType < StandardError
  end

  class IndexExceedsListSize < StandardError
  end

  class InvalidPriorityValue < StandardError
  end

  class NoFoundItemsOfType < StandardError
  end

  class NotUniqueUser < StandardError
  end

  class NotValidPassword < StandardError
  end

  class AuthenticationFailure < StandardError
  end

  class NoUserFound < StandardError
  end
end
