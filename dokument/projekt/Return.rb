class Return < StandardError
    attr_reader :val
    def initialize val={}
        super
        @val = val
    end
end
