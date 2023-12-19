puts "建立資料中..."
5.times do
  email = Faker::Internet.email
user = User.find_or_create_by(email:) do |u|
  u.password = '123456'
end

puts "使用者：#{user.email}"

unless user.shop.present?
  shop = Shop.new(
    user_id: user.id,
    title: Faker::Book.title,
    description: Faker::Lorem.paragraph,
    tel: "(0#{rand(1..9)})#{Faker::Number.number(digits: 4)}-#{Faker::Number.number(digits: 4)}",
    city: '台北市',
    district: '中正區',
    street: "衡陽路#{rand(1..500)}巷#{rand(1..50)}號"
  )

  if shop.save
    puts "店家：#{shop.title} 已建立"
  else
    puts '店家建立失敗'
    puts "錯誤訊息：#{shop.errors.full_messages.join(', ')}"
  end
else
  puts '該使用者已擁有店家'
end

end
