Factory.define :task do |t|
  t.title "Some task"
  t.description "Doing something"
  t.public_read true
  t.association :container
  t.association :author
  t.start_at    Time.now
  t.recurrence  1
end

