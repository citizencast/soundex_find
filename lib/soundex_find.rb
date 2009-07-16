# SoundexFind
module WGJ #:nodoc:
  module SoundexFind #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      
      def soundex_columns(columns, options = {})
        include WGJ::SoundexFind::InstanceMethods
        extend WGJ::SoundexFind::SingletonMethods
        
        before_save :update_soundex

        self.sdx_columns = (columns.is_a?(Array) ? columns : [columns])
        self.sdx_options = options
      end
    end
    
    # This module contains class methods
    module SingletonMethods
      @sdx_columns = []
      @options = {}

      def sdx_columns=(a)
        @sdx_columns = a  
      end
      
      def sdx_columns
        @sdx_columns
      end
      
      def sdx_options=(o)
        @sdx_options = o  
      end
      
      def sdx_options
        @sdx_options
      end
      
      def soundex_find(*args)
        options = args.extract_options!
        
        sdx = (self.sdx_options[:start] ? '' : '%') +
                self.soundex(options.delete(:soundex)) +
                (self.sdx_options[:end] ? '' : '%')
        
        #TODO: currently supports only one column
        with_scope :find => { :conditions => ["#{self.sdx_columns[0]}_soundex LIKE ?", sdx] } do
          items = self.find(args.first, options) 
        end
      end
      
      #TODO: Use resource file, and support more languages, or alternate charsets.
      SoundexChars = 'BPFVCSKGJQXZDTLMNR'
      SoundexNums  = '111122222222334556'
      SoundexCharsEx = '^' + SoundexChars
      SoundexCharsDel = '^A-Z'
    
      # desc: http://en.wikipedia.org/wiki/Soundex
      # adapted from Alexander Ermolaev
      # http://snippets.dzone.com/posts/show/4530
      def soundex(string)
        str = string.upcase.delete(SoundexCharsDel).squeeze
    
        limit = self.sdx_options[:limit]
        
        if self.sdx_options[:strict]
          str[0 .. 0] + str[1 .. -1].
              delete(SoundexCharsEx).
              tr(SoundexChars, SoundexNums)[0 .. (limit ? (limit-1) : -1)] rescue ''
        else
          str[0 .. -1].
              delete(SoundexCharsEx).
              tr(SoundexChars, SoundexNums)[0 .. (limit ? (limit) : -1)] rescue ''
        end
      end
      
    end
    
    # This module contains instance methods
    module InstanceMethods

      def update_soundex
        self.class.sdx_columns.each {|c|
          self.send("#{c}_soundex=", self.class.soundex(self.send(c)))
        }
      end
      
    end
  end
end



