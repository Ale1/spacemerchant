
  ROMANS =  {'I'=>1,'V'=>5,'X'=>10,'L'=>50}

  class MerchantError < StandardError
  end

  class RomanError < MerchantError
  end

  class AlienError < MerchantError
  end

  class PriceError < MerchantError
  end