-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- Basic
import XMonad
import Data.Monoid
import System.Exit
import System.IO

-- Utils
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import ViewDoc

-- Actions
import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow
import XMonad.Actions.NoBorders
import XMonad.Actions.SpawnOn

-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops

-- Layouts
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
--import XMonad.Layout.MultiToggle



-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "termite"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#282828"
myFocusedBorderColor = "#b16286"

-- scratchpad = [
--   -- run htop in xterm, find it by title, use default floating window placement
--     NS "htop" "xterm -e htop" (title =? "htop") defaultFloating

--   -- run stardict, find it by class name, place it in the floating window
--   -- 1/6 of screen width from the left, 1/6 of screen height
--   -- from the top, 2/3 of screen width by 2/3 of screen height
--   -- , NS "xfce4-terminal" "xfce4-terminal" (className =? "Xfce4-Terminal")
--   --       (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
-- ]

-- myScratchPads :: [NamedScratchpad]
-- myScratchPads = [
-- -- run htop in xterm, find it by title, use default floating window placement
--     NS "htop" "xterm -e htop" (title =? "htop") defaultFloating ,

-- -- run stardict, find it by class name, place it in the floating window
-- -- 1/6 of screen width from the left, 1/6 of screen height
-- -- from the top, 2/3 of screen width by 2/3 of screen height
--     NS "stardict" "stardict" (className =? "Stardict")
--         (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) ,

-- -- run gvim, find by role, don't float
--     NS "notes" "gvim --role notes ~/notes.txt" (role =? "notes") nonFloating
-- ] where role = stringProperty "WM_WINDOW_ROLE"

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "pipe-viewer" spawnPipe findPipe managePipe
                , NS "gtk-pipe-viewer" spawnGTKPipe findGTKPipe manageGTKPipe
                , NS "mpv" spawnMpv findMpv manageMpv
                , NS "qalculate-gtk" spawnGTKqalc findGTKqalc manageGTKqalc
                ]
  where
    spawnTerm  = myTerminal ++ " --name ns-terminal"
    findTerm   = resource =? "ns-terminal"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnPipe  = myTerminal ++ " -n ns-pipe-viewer 'pipe-viewer'"
    findPipe   = resource =? "ns-pipe-viewer"
    managePipe = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMpv  = "mpv https://www.youtube.com/watch?v=kcNpBNpvyc4"
    findMpv   = resource =? "gl"
    manageMpv = customFloating $ W.RationalRect l t w h
               where
                 h = 0.45
                 w = 0.45
                 t = 1 -h
                 l = 1 -w
    spawnGTKPipe  = "gtk-pipe-viewer"
    findGTKPipe   = resource =? "gtk-pipe-viewer"
    manageGTKPipe = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnGTKqalc  = "qalculate-gtk"
    findGTKqalc   = resource =? "qalculate-gtk"
    manageGTKqalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.7
                 w = 0.5
                 t = 0.85 -h
                 l = 0.75 -w



------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

-- myLayoutHook = id
--     . smartBorders
--     . mkToggle (NOBORDERS ?? FULL ?? EOT)
--     . mkToggle (single MIRROR)
--     $ avoidStruts (tiled ||| Mirror tiled ||| Full)

myLayoutHook = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

-- myManageHook = composeAll
--     [-- className =? "mpv"            --> doFloat
--       className =? "gimp"           --> doFloat
--     , resource  =? "desktop_window" --> doIgnore
--     , resource  =? "kdesktop"       --> doIgnore ] <+> namedScratchpadManageHook myScratchPads

myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat]
        <+> namedScratchpadManageHook myScratchPads
        -- <+> manageSpawn

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

myLogHook :: X ()
myLogHook = return()

------------------------------------------------------------------------
-- Startup hook

spawnToWorkspace :: String -> String -> X ()
spawnToWorkspace workspace program = do
  spawn program
  windows $ W.greedyView workspace

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
  -- Set Background
  --sawnOnce "hsetroot -solid \"#283927\" &"
  spawnOnce "hsetroot -fill \"/home/hamza/pix/wallpapers/gruvbox-blocky-colourful-waveform.png\" &"

  -- Keyboard go brrrrrrrrrrr
  spawnOnce "sh ~/.xprofile"

  -- Transparency
  spawnOnce "picom &"

  -- Hide mouse on no movement
  spawnOnce "unclutter &"

  -- Emacs :D
  -- spawnOnce "emacs --daemon"

  -- -- Emacs :D
  spawnToWorkspace "1:1" "emacs --daemon && emacsclient -c &"
  -- -- Common Lisp Browser ;)
  spawnToWorkspace "2:2" "nyxt &"
  -- -- Need Help (SOS)
  spawnToWorkspace "8:8" (myTerminal ++ " -e gomuks &")
  -- -- gotta watch youtube ^.^
  spawnToWorkspace "9:9" "gtk-pipe-viewer &"

  -- X Screen Saver... Very cool
  spawnOnce "xscreensaver -no-splash &"

  -- Draw on the Screen!
  spawnOnce "gromit-mpx &"

  -- slock (Suckless X Display Locker) auto-run after some minutes idle
  --spawnOnce "xautolock -time 1 -locker slock"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "rofi -show run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "dmenu_run")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)


     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. controlMask, xK_j   ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- Scratchpad
    -- , ((modm .|. shiftMask, xK_s),      scratchpadSpawnActionTerminal myTerminal)
    -- , ((modm .|. controlMask .|. shiftMask, xK_h), namedScratchpadAction scratchpads "htop")
    -- , ((modm .|. controlMask .|. shiftMask, xK_x), namedScratchpadAction scratchpads "xfce4-terminal")
    -- , ("M-C-<Return>", namedScratchpadAction myScratchPads "terminal")
    , ((modm .|. controlMask , xK_Return),          namedScratchpadAction myScratchPads "terminal")
    , ((modm .|. controlMask , xK_s),               namedScratchpadAction myScratchPads "pipe-viewer")
    , ((modm .|. controlMask , xK_y),               namedScratchpadAction myScratchPads "gtk-pipe-viewer")
    , ((modm .|. controlMask .|. shiftMask , xK_q), namedScratchpadAction myScratchPads "qalculate-gtk")
    , ((modm .|. controlMask , xK_m),               namedScratchpadAction myScratchPads "mpv")

    -- Hamza's Custom Keybindings

    , ((modm .|. shiftMask, xK_w),                      spawn "nyxt")
    , ((modm .|. shiftMask, xK_e),                      spawn "emacsclient -c")
    , ((modm .|. shiftMask, xK_g),                      spawn "gimp")
    , ((modm .|. shiftMask, xK_y),                      spawn "gtk-pipe-viewer")
    , ((modm .|. shiftMask, xK_l),                      spawn "slock")
    , ((modm .|. controlMask .|. shiftMask, xK_h),      spawn "zzz")
    , ((modm .|. shiftMask, xK_f),                      spawn "dmenufm")

    -- scrotting
    , ((0, xK_Print),                   spawn "scrot ~/pix/screenshots/%b%d::%H:%M:%S.png")
    , ((controlMask, xK_Print),         spawn "sleep 0.2; scrot -s ~/pix/screenshots/%b%d::%H:%M:%S.png")

    -- a basic CycleWS setup

    , ((modm,               xK_Down),   nextWS)
    , ((modm,               xK_Up),     prevWS)
    , ((modm .|. shiftMask, xK_Down),   shiftToNext)
    , ((modm .|. shiftMask, xK_Up),     shiftToPrev)
    , ((modm,               xK_Right),  nextScreen)
    , ((modm,               xK_Left),   prevScreen)
    , ((modm .|. shiftMask, xK_Right),  shiftNextScreen)
    , ((modm .|. shiftMask, xK_Left),   shiftPrevScreen)
    , ((modm,               xK_Tab), toggleWS :: X ())

    -- Copy windows to all workspaces
    --, ((modm .|. shiftMask, xK_c     ), kill1) -- @@ (only remove from current workspace) Close the focused window
    --, ((modm .|. shiftMask, xK_b     ), runOrCopy "mpv" (resource =? "gl")) -- @@ run or copy mpv
    , ((modm, xK_v ), windows copyToAll) -- @@ Make focused window always visible
    , ((modm .|. shiftMask, xK_v ),  killAllOtherCopies) -- @@ kill all other copies of window (window state back)

    -- Toggle Borders (NoBorders)
    , ((modm,  xK_g ),    withFocused toggleBorder)
    --, ((modm,  xK_x ),    sendMessage $ Toggle MIRROR)

    -- -- XMonad-Sessions

    -- ,((modm, xK_s), toggleSaveState)
    -- ,((modm .|. shiftMask, xK_s), launchDocuments)

    ]
    ++

    -- mod-[1..9] @@ Switch to workspace N
    -- mod-shift-[1..9] @@ Move client to workspace N
    -- mod-control-shift-[1..9] @@ Copy client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 ..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (copy, shiftMask .|. controlMask)]]
    ++

    --
    -- Did this cz of my keybindings to open applications
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-ctrl-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, controlMask)]]

    -- --
    -- -- mod-[1..9], Switch to workspace N
    -- -- mod-shift-[1..9], Move client to workspace N
    -- --
    -- [((m .|. modm, k), windows $ f i)
    --     | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    --     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- ++

    -- --
    -- -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    -- --
    -- -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    -- --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    -- --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]



------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc <- spawnPipe "xmobar -x 0 /home/hamza/.config/xmobar/xmobarrc"
  xmonad $ docks defaults
    { --layoutHook = avoidStruts  $  layoutHook defaultConfig,
    logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "#b8bb26" "" . shorten 100
                }
    --, manageHook = namedScratchpadManageHook scratchpads
    --, manageHook = manageSpawn -- <+> manageHook default
    }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        -- keys               = (\c -> myKeys c `M.union` keys defaultConfig c), 
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayoutHook,
        manageHook         = manageSpawn <+> myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
