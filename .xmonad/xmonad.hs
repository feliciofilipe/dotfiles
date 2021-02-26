import System.IO
import System.Exit

import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers(doRectFloat ,doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Config.Desktop
import XMonad.Config.Azerty

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce

import XMonad.Actions.SpawnOn
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Actions.CycleWS
import XMonad.Hooks.UrgencyHook
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
---import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens


import XMonad.Layout.CenteredMaster(centerMaster)

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad (liftM2)
import qualified DBus as D
import qualified DBus.Client as D


i    = "\61820"
ii   = "\61728"
iii  = "\57351"
iv   = "\62692"
v    = "\61729"
vi   = "\xf109"
vii  = "\61825"
viii = "\61848"
ix   = "\62354"
x    = "\61884"

myStartupHook = do
    spawn "nitrogen --restore tiled"
    spawn "$HOME/.xmonad/scripts/autostart.sh &"

-- colours
normBord = "#313742"
focdBord = "#313742"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myModMask = mod4Mask

encodeCChar = map fromIntegral . B.unpack

myFocusFollowsMouse = True

myBorderWidth = 3

--myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]
myWorkspaces    = [i,ii,iii,iv,v,vi,vii,viii,ix,x]

myTerminal = "kitty"

myBrowser = "firefox-developer-edition"

myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 0) | x <- my1Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 1) | x <- my2Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 2) | x <- my3Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 3) | x <- my4Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 4) | x <- my5Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 5) | x <- my6Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 6) | x <- my7Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 7) | x <- my8Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 8) | x <- my9Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo (myWorkspaces !! 9) | x <- my10Shifts]
    ]
    where
    doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = [ "Arandr"
                , "Arcolinux-tweak-tool.py"
                , "Arcolinux-welcome-app.py"
                , "Galculator"
                , "feh"
                , "mpv"
                , "Xfce4-terminal"
                ]
    myTFloats = [ "Downloads"
                , "Save As..."
                ]
    myRFloats  = []
    myIgnores  = ["desktop_window"]
    my1Shifts  = []
    my2Shifts  = []
    my3Shifts  = ["firefoxdeveloperedition","Firefox Developer Edition"]
    my4Shifts  = ["jetbrains-idea"]
    my5Shifts  = ["code-oss","Code","code"]
    my6Shifts  = ["VirtualBox","virtualbox","Illustrator","illustrator"]
    my7Shifts  = ["trello","Trello"]
    my8Shifts  = ["slack","Slack"]
    my9Shifts  = ["discord","Discord"]
    my10Shifts = ["Spotify","Spotify Free","spotify"]




myLayout = spacingRaw True (Border 5 5 5 5) True (Border 5 5 5 5) True $ avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| Full
    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]


startup = do
  spawn "firefox-developer-edition"
  spawn "trello"
  spawn "slack"
  spawn "discord"
  --spawn "code"
  --spawnOn vi "virtualbox"
  spawnOn x  "spotify"
  spawnOn ii myTerminal
  spawnOn ii myTerminal
  spawnOn ii myTerminal
  --spawnAndDo (doRectFloat $ W.RationalRect 0.25 0.25 0.5 0.5) $ myTerminal
  --windows $ W.greedyView i


-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------

  -- STARTUP

  [ ((modMask .|. shiftMask, xK_s), startup)

  -- SUPER + FUNCTION KEYS

  , ((modMask, xK_b), spawn $ "mysql-workbench" )
  , ((modMask, xK_c), spawn $ "code" )
  , ((modMask, xK_d), spawn $ "discord" )
  , ((modMask, xK_f), spawn $ "thunar" )
  , ((modMask, xK_g), spawn $ "gimp" )
  , ((modMask, xK_h), spawn $ "urxvt 'htop task manager' -e htop" )
  , ((modMask, xK_j), spawn $ "intellij-idea-ultimate" )
  , ((modMask, xK_s), spawn $ "spotify" )
  , ((modMask, xK_t), spawnAndDo (doRectFloat $ W.RationalRect 0.25 0.25 0.5 0.5) myTerminal )
  , ((modMask, xK_v), spawn $ "pavucontrol" )
  , ((modMask, xK_x), spawn $ "kitty -e nvim .xmonad/xmonad.hs")
  , ((modMask, xK_y), spawn $ "polybar-msg cmd toggle" )
  , ((modMask, xK_w), spawn $ myBrowser )
  , ((modMask, xK_Return), spawn $ myTerminal )

  -- SUPER + SHIFT KEYS

  , ((modMask .|. shiftMask , xK_Return ), spawn $ "rofi -show run")
  , ((modMask .|. shiftMask , xK_t), withFocused $ windows . W.sink)
  , ((modMask .|. shiftMask , xK_f ), sendMessage $ Toggle NBFULL)
  , ((modMask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
  , ((modMask .|. shiftMask , xK_c ), kill)
  , ((modMask .|. shiftMask , xK_q ), io (exitWith ExitSuccess))

   -- XRANDR
  , ((modMask .|. mod1Mask , xK_Up ), spawn $ "xrandr --output HDMI2 --auto --above eDP1 && xmonad --restart")
  , ((modMask .|. mod1Mask , xK_Right ), spawn $ "xrandr --output HDMI2 --auto --right-of eDP1 && xmonad --restart")
  , ((modMask .|. mod1Mask , xK_Down ), spawn $ "xrandr --output HDMI2 --auto --below eDP1 && xmonad --restart")
  , ((modMask .|. mod1Mask , xK_Left ), spawn $ "xrandr --output HDMI2 --auto --left-of eDP1 && xmonad --restart")

  -- ALT + ... KEYS

  , ((mod1Mask, xK_F2), spawn $ "gmrun" )
  , ((mod1Mask, xK_F3), spawn $ "xfce4-appfinder" )

  --CONTROL + SHIFT KEYS

  , ((controlMask .|. shiftMask , xK_Escape ), spawn $ "xfce4-taskmanager")

  --SCREENSHOTS

  , ((0, xK_Print), spawn $ "xfce4-screenshooter" )


  --MULTIMEDIA KEYS

  -- Mute volume
  , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")
  -- Decrease volume
  , ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-")
  -- Increase volume
  , ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+")
  -- Increase brightness
  , ((0, xF86XK_MonBrightnessUp),  spawn $ "xbacklight -inc 5")
  -- Decrease brightness
  , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 5")
  , ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause")
  , ((0, xF86XK_AudioNext), spawn $ "playerctl next")
  , ((0, xF86XK_AudioPrev), spawn $ "playerctl previous")
  , ((0, xF86XK_AudioStop), spawn $ "playerctl stop")


  --------------------------------------------------------------------
  --  XMONAD LAYOUT KEYS

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)
  --Focus selected desktop
  , ((modMask, xK_Tab), nextWS)
  --Focus selected desktop
  , ((modMask, xK_Down ), prevWS)
  --Focus selected desktop
  , ((modMask, xK_Up ), nextWS)
  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
  -- Move focus to the next window.
  , ((modMask, xK_Left), windows W.focusDown)
  -- Move focus to the previous window.
  , ((modMask, xK_Right), windows W.focusUp)
  -- Move focus to the previous monitor.
  , ((modMask .|. shiftMask, xK_Left), prevScreen)
  -- Move focus to the next monitor.
  , ((modMask .|. shiftMask, xK_Right), nextScreen)
  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_Down), prevScreen)
  -- Move focus to the next monitor.
  , ((modMask .|. shiftMask, xK_Up), nextScreen)
  -- Swap the focused window with the next window.
  , ((modMask .|. controlMask, xK_Left), windows W.swapDown)
  -- Swap the focused window with the previous window.
  , ((modMask .|. controlMask, xK_Right), windows W.swapUp)
  -- Shrink the master area.
  --, ((controlMask .|. shiftMask , xK_h), sendMessage Shrink)
  -- Expand the master area.
  --, ((controlMask .|. shiftMask , xK_l), sendMessage Expand)
  -- Push window back into tiling.
  --, ((controlMask .|. shiftMask , xK_t), withFocused $ windows . W.sink)
  -- Increment the number of windows in the master area.
  --, ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))
  -- Decrement the number of windows in the master area.
  --, ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))

  ]
  ++
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
  --qwerty users use this line
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]
  ++
  -- ctrl-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. controlMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


main :: IO ()
main = do

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]


    xmonad . ewmh $
  --Keyboard layouts
  --qwerty users use this line
            myBaseConfig
  --French Azerty users use this line
            --myBaseConfig { keys = azertyKeys <+> keys azertyConfig }
  --Belgian Azerty users use this line
            --myBaseConfig { keys = belgianKeys <+> keys belgianConfig }

                {startupHook = myStartupHook
, layoutHook = myLayout ||| layoutHook myBaseConfig
, manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
, modMask = myModMask
, borderWidth = myBorderWidth
, handleEventHook    = handleEventHook myBaseConfig <+> fullscreenEventHook
, focusFollowsMouse = myFocusFollowsMouse
, workspaces = myWorkspaces
, focusedBorderColor = focdBord
, normalBorderColor = normBord
, keys = myKeys
, mouseBindings = myMouseBindings}
