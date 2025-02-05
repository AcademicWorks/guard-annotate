require 'spec_helper'

describe Guard::Annotate do
  subject { Guard::Annotate.new }
  
  context "#initialize options" do
    describe "notify" do
      it "should be true by default" do
        subject.should be_notify
      end
      
      it "should allow notifications to be turned off" do
        subject = Guard::Annotate.new( [], :notify => false )
        subject.options[:notify].should be_false
      end

      it "should use 'before' position by default" do
        subject.options[:position].should == 'before'
      end
      
      it "should allow user to customize position (before)" do
        subject = Guard::Annotate.new( [], :position => 'before' )
        subject.options[:position].should == 'before'
        subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
        subject.start
      end

      it "should allow user to customize position (after)" do
        subject = Guard::Annotate.new( [], :position => 'after' )
        subject.options[:position].should == 'after'
        subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p after")
        subject.start
      end
      
      describe "routes" do
        it "should not run routes by default" do
          subject.options[:routes].should be_false
        end
        
        it "should allow the users to run routes if desired" do
          subject = Guard::Annotate.new( [], :routes => true)
          subject.should_receive(:system).twice
          subject.start
        end
      end
      
      describe "tests & fixtures" do
        it "should not run tests annotations by default" do
          subject.options[:tests].should be_false
        end
        
        it "should allo user to run tests and fixtures annotations if desired" do
          subject = Guard::Annotate.new( [], :tests => true )
          subject.should_receive(:system).with("bundle exec annotate  -p before")
          subject.start
        end
      end
    end
  end
  
  context "start" do
    it "should run annotate command" do
      subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
      subject.start
    end
    
    it "should return false if annotate command fails" do
      subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before").and_return(false)
      subject.start.should be_false
    end
  end
  
  context "stop" do
    it "should be a noop (return true)" do
      subject.stop.should be_true
    end
  end  
  
  context "run_all" do
    it "should be a noop (return true)" do
      subject.run_all.should be_true
    end
  end  
  
  context "reload" do
    it "should run annotate command" do
      subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
      subject.reload
    end
    
    it "should return false if annotate command fails" do
      subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before").and_return(false)
      subject.reload.should be_false
    end
  end
  
  context "run_on_change" do
    it "should run annotate command" do
      subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
      subject.run_on_change
    end
    
    it "should return false if annotate command fails" do
      subject.should_receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before").and_return(false)
      subject.run_on_change.should be_false
    end
  end
end