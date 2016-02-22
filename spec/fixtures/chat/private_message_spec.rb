require "rails_helper"

RSpec.describe PrivateMessage do
    
    describe PrivateMessage::Validator do
        
        it ".validate_channel - valid" do
            expect(PrivateMessage.validate_channel?("ws.chat:")).to be true
        end
        
        it ".validate_channel - invalid" do
            expect(PrivateMessage.validate_channel?("ws.private")).to be false
        end
    end
    
end