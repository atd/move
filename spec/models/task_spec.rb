require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  before(:all) do
    @time_now = Time.now
  end 

  describe "monthly" do
    before do
      @task = Factory(:task, :recurrence => 3, :start_at => @time_now, :recurrence_match => "#{ (@time_now.mday / 7.0 ).ceil } #{ @time_now.wday }")
    end

    it "should have right recurrence_match" do
      assert @task.match_recurrence?
    end
  end

end

