module Pollett
  class Mailer < Pollett.config.parent_mailer
    include Concerns::Mailers::Mailer
  end
end
