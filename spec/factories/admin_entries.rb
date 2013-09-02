# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_entry, :class => 'Admin::Entry' do
    short "MyString"
    long "MyText"
  end
end
