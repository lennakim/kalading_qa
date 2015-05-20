# 本地不用执行此文件

city = City.beijing

3.times do |i|
  i += 1
  u = User.new
  u.phone_num = "1865555100#{i}"
  u.password = '1' * 6
  u.name = "问答测试客服#{i}"
  u.roles = ['6']
  u.city = city
  u.email = "qa_test_kefu_#{i}@kalading.com"
  u.save!
end

1.times do |i|
  i += 1
  u = User.new
  u.phone_num = "1865555200#{i}"
  u.password = '1' * 6
  u.name = "问答测试客服主管#{i}"
  u.roles = ['6', '11']
  u.city = city
  u.email = "qa_test_kefuzhuguan_#{i}@kalading.com"
  u.save!
end

3.times do |i|
  i += 1
  u = User.new
  u.phone_num = "1865555400#{i}"
  u.password = '1' * 6
  u.name = "问答测试专家#{i}"
  u.roles = ['12']
  u.city = city
  u.email = "qa_test_zhuanjia_#{i}@kalading.com"
  u.save!
end

1.times do |i|
  i += 1
  u = User.new
  u.phone_num = "1865555500#{i}"
  u.password = '1' * 6
  u.name = "问答测试总裁#{i}"
  u.roles = ['2']
  u.city = city
  u.email = "qa_test_zongcai_#{i}@kalading.com"
  u.save!
end
