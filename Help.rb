require 'fox16'
require 'win32/clipboard'

include Fox

$state_names = %w{頭 右手 左手 胴体 左足 右足}

class ButtonWindow < FXMainWindow

    def initialize(app)
        
        super(app, "CSM Helper", :opts => DECOR_ALL, :x => 100, :y => 100)

        controls = FXVerticalFrame.new(self,PACK_UNIFORM_WIDTH)
        
        matrix = FXMatrix.new(self, 7,
            MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y)
        
        FXHorizontalSeparator.new(self,
          LAYOUT_SIDE_TOP|SEPARATOR_GROOVE|LAYOUT_FILL_X)
        FXLabel.new(matrix, "x座標", nil,
            LAYOUT_CENTER_Y|LAYOUT_CENTER_X|JUSTIFY_RIGHT|LAYOUT_FILL_ROW)
        @textfield3 = FXTextField.new(matrix, 10, nil, 0,
            TEXTFIELD_INTEGER|LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)

        FXLabel.new(matrix, "y座標", nil,
            LAYOUT_CENTER_Y|LAYOUT_CENTER_X|JUSTIFY_RIGHT|LAYOUT_FILL_ROW)
        @textfield2 = FXTextField.new(matrix, 10, nil, 0,
            TEXTFIELD_INTEGER|LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
            FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)

        FXLabel.new(matrix, "z座標", nil,
            LAYOUT_CENTER_Y|LAYOUT_CENTER_X|JUSTIFY_RIGHT|LAYOUT_FILL_ROW)
        @textfield4 = FXTextField.new(matrix, 10, nil, 0,
            TEXTFIELD_INTEGER|LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)

        FXLabel.new(matrix, "UVたて", nil, LAYOUT_CENTER_Y|LAYOUT_CENTER_X|JUSTIFY_RIGHT|LAYOUT_FILL_ROW)
        @textfield5 = FXTextField.new(matrix, 10, nil, 0, TEXTFIELD_INTEGER|LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)

        FXLabel.new(matrix, "よこ", nil, LAYOUT_CENTER_Y|LAYOUT_CENTER_X|JUSTIFY_RIGHT|LAYOUT_FILL_ROW)
        @textfield6 = FXTextField.new(matrix, 10, nil, 0, TEXTFIELD_INTEGER|LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)

        FXLabel.new(matrix, "準拠", nil,
            LAYOUT_CENTER_Y|LAYOUT_CENTER_X|JUSTIFY_RIGHT|LAYOUT_FILL_ROW)
        states = FXListBox.new(matrix,
            :opts => LISTBOX_NORMAL|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X)      
          states.numVisible = 6
        $state_names.each { |name| states.appendItem(name) }
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)

        btn = FXButton.new(matrix,"crear",
            :opts => FRAME_RAISED|FRAME_THICK,
            :width => 100, :height => 200)
        
        btn.connect(SEL_COMMAND) do |sender, sel, data|
            fx = @textfield3.text
            fy = @textfield2.text
            fz = @textfield4.text
            uy = @textfield6.text
            ux = @textfield5.text
            case states.currentItem
            when 0
                parts = "HEAD"
            when 1
                parts = "ARM0"
            when 2
                parts = "ARM1"
            when 3
                parts = "BODY"
            when 4
                parts = "LEG1"
            when 5
                parts = "LEG0"
            end
            answer ="New Part
#{parts}
New Part
#{fx}
#{fy}
#{fz}
1
1
1
#{uy}
#{ux}
"
            @textfield9.text = answer
        end
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
        FXFrame.new(matrix, LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)

        buttown = FXButton.new(matrix,"copiar",
            :opts => FRAME_SUNKEN,
            :width => 100, :height => 200)
        buttown.connect(SEL_COMMAND) do |sender, sel, data|
          Win32::Clipboard.set_data(@textfield9.text, Win32::Clipboard::UNICODETEXT)
        end

        @textfield9 = FXTextField.new(controls, 30, nil, 70,
            TEXTFIELD_READONLY|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_Y)

    end
    def create
        super
        show(PLACEMENT_SCREEN)
    end
end
if __FILE__ == $0
    
    application = FXApp.new
    
    ButtonWindow.new(application)
    
    application.create
  
    application.run
end
        
