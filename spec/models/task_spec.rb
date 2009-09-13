require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  before(:all) do
    @time_now = Time.now
  end 

  describe "monthly" do
    before do
      @task = Factory(:task, :recurrence => 3, :start_at => @time_now)
    end

    it "should have right occurrences" do
      assert @task.occurrences(@time_now.months_since(1)) == 1
    end
  end

end

