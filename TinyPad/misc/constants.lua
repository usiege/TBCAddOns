local _,t = ...
t.constants = {}

-- bindings.xml constants
BINDING_HEADER_TINYPAD = "TinyPad"
BINDING_NAME_TINYPAD_TOGGLE = "Show/Hide TinyPad"
BINDING_NAME_TINYPAD_SEARCH = "Search within TinyPad"

-- size of resize grip on main frame
t.constants.RESIZE_GRIP_SIZE = 12

-- minimize size of the TinyPad frame
t.constants.MIN_WINDOW_WIDTH = 210
t.constants.MIN_WINDOW_HEIGHT = 140

t.constants.SMALL_SCALE = 1
t.constants.LARGE_SCALE = 1.25

-- threshholds for adaptive layout: 210-247 narrow; 248-281 medium; 282+ wide
t.constants.MIN_NARROW_WIDTH = 254
t.constants.MIN_MEDIUM_WIDTH = 297 -- 248
t.constants.MIN_WIDE_WIDTH = 330 -- 282
t.constants.MIN_INSTRUCTION_WIDTH = 222 -- minimum width that search instruction should be shown

-- buttons are ordinarily 24x24, but shrink to 20x20 when window is narrow
t.constants.BUTTON_SIZE_NORMAL = 24
t.constants.BUTTON_SIZE_SMALL = 20

-- time (in seconds) of the animation for the main window to fade in or out
t.constants.FADE_INOUT_DURATION = 0.25
-- time (in seconds) between checks for the mouse being over the main window (while it's up)
t.constants.FADE_TICKER_DURATION = 0.1

-- the amount to subtract from the main window's width to calculate the editbox width
t.constants.EDITBOX_WIDTH_ADJUSTMENT_NORMAL = 44

-- editboxes are not designed to hold massive amounts of text; raise this at your own risk
t.constants.MAX_EDITBOX_CHARACTERS = 8192

-- width of the bookmarks panel that contains the list of bookmarks
t.constants.BOOKMARKS_PANEL_WIDTH = 132
-- height of the bookmark list buttons in t.bookmarks
t.constants.BOOKMARK_HEIGHT = 18

-- amount to adjust widths when a scrollbar is present
t.constants.SCROLLBAR_WIDTH = 22

t.constants.TOOLTIP_SUBTEXT_COLOR = "\124cffaaaaaa"

-- on an EditFocusLost, the time before a decision is made on whether focus has returned
t.constants.EDIT_FOCUS_TIMER = 0.1

-- default position (angle) of the minimap button
t.constants.DEFAULT_MINIMAP_POSITION = -65

-- height of the "grip" at the top of the toolbar to move the window
t.constants.TITLE_GRIP_HEIGHT = 8

-- page added to TinyPad if there are no pages (first use or savedvar nil'ed)
t.constants.WELCOME_MESSAGE = "Welcome to TinyPad!\n\nTinyPad is a simple but powerful notepad addon that's easy to use.\n\nSome features include:\n- Resizable\n- Undo/Redo\n- Search\n- Bookmarks\n- Runs Lua Scripts\n- Link Support\n- Adaptive UI\n- More!\n\nTo summon: /pad or /tinypad, bind a key, or turn on a minimap button in the settings panel."    

-- colors of the bookmark buttons in normal(up) and pushed(down) states, and also while pinned
-- these are r,g,b shades of grey, so 0.3 is r,g,b 0.3,0.3,0.3
t.constants.BOOKMARK_UP_LIGHT = 0.3
t.constants.BOOKMARK_UP_BACK = 0.2
t.constants.BOOKMARK_UP_DARK = 0.1
t.constants.BOOKMARK_DOWN_LIGHT = 0
t.constants.BOOKMARK_DOWN_BACK = 0.05
t.constants.BOOKMARK_DOWN_DARK = 0.2
t.constants.BOOKMARK_UP_PINNED_LIGHT = 0.2
t.constants.BOOKMARK_UP_PINNED_BACK = 0.1
t.constants.BOOKMARK_UP_PINNED_DARK = 0.05
t.constants.BOOKMARK_DOWN_PINNED_LIGHT = 0
t.constants.BOOKMARK_DOWN_PINNED_BACK = 0.05
t.constants.BOOKMARK_DOWN_PINNED_DARK = 0.1

