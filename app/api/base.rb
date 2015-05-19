class Base < Grape::API
  mount V2::Root
end