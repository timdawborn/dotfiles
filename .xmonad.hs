import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Prompt
import XMonad.Prompt.Man
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)

import System.IO
import qualified Data.Map as M


main = do
    xmobar <- spawnPipe "/usr/bin/xmobar"
    xmonad $ defaultConfig
        { borderWidth        = 1
        , focusedBorderColor = "#ff6666"
        , normalBorderColor  = "#2222aa"
        , workspaces         = map show [1 .. 10 :: Int]
        , terminal           = "xterm"
        , modMask            = mod4Mask  -- Rebind Mod to the Windows key
        , layoutHook         = avoidStruts $ layoutHook defaultConfig
        , manageHook         = myManageHook <+> manageDocks
        , logHook            = myLogHook xmobar
        , keys               = \c -> myKeys c `M.union` keys defaultConfig c
        }

    where

        myLogHook :: Handle -> X ()
        myLogHook h = dynamicLogWithPP $ xmobarPP
            { ppOutput = hPutStrLn h
            , ppTitle = xmobarColor "green" "" . shorten 50
            }

        myManageHook :: ManageHook
        myManageHook = composeAll
            [ title =? "xclock" --> doFloat
            , className =? "Gimp" --> doFloat
            ]

        myKeys conf@(XConfig {modMask = modm}) = M.fromList $
            [ ((modm .|. shiftMask, xK_z), spawn "xscreensaver-command -lock") -- launch screensaver (mod+shift+z)
            , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")           -- screenshot
            , ((0, xK_Print), spawn "scrot")                                   -- screenshot
            , ((modm .|. shiftMask, xK_m), manPrompt defaultXPConfig)          -- launch manpage prompt
            ]

        {-
        myFocusedBorderColor :: String
        myFocusedBorderColor =
            if length (W.integrate' W.stack windows) == 1
              then "ff6666"
              else "000000"
        -}


