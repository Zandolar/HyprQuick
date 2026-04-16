pragma Singleton

import QtQuick
import Quickshell
import "~/.config/quickshell"

Singleton {
  property Item get: matugen

  Colors {

    id: colors
  }
  
  Item {
    id: windowsXP

    property string barBgColor: "#88235EDC"
    property string buttonBorderColor: "#99000000"
    property bool buttonBorderShadow: false
    property string buttonBackgroundColor: "#1111CC"
    property bool onTop: false
    property string iconColor: "green"
    property string iconPressedColor: "green"
    property Gradient barGradient: black.barGradient
  }

  Item {
    id: black

    property string barBgColor: "#cc000000" 
    property string buttonBorderColor: "#BBBBBB"
    property string buttonBackgroundColor: "#222222"
    property bool buttonBorderShadow: true
    property bool onTop: true
    property string iconColor: "blue"
    property string iconPressedColor: "dark_blue"
  }

  Item {
    id: nordic

    // Nord color palette
    property string barBgColor: "#aa2E3440"  // Nord0 - Polar Night
    property string buttonBorderColor: "#4C566A"  // Nord3 - Polar Night
    property string buttonBackgroundColor: "#3D4550"
    property bool buttonBorderShadow: true
    property bool onTop: true
    property string iconColor: "#88C0D0"  // Nord7 - Frost
    property string iconPressedColor: "#81A1C1"  // Nord9 - Frost
  }

  Item {
    id: cyberpunk

    // Tokyo Neon color palette
    property string barBgColor: "#881A0B2E"  // Deep purple-black
    property string buttonBorderColor: "#FF2A6D"  // Neon pink
    property string buttonBackgroundColor: "#1A1A2E"  // Dark blue-black
    property bool buttonBorderShadow: true
    property bool onTop: true
    property string iconColor: "#05D9E8"  // Electric blue
    property string iconPressedColor: "#FF2A6D"  // Neon pink
  }

  Item {
    id: material

    // Material Design 3 color palette
    property string barBgColor: "#cc1F1F1F"  // Surface dark
    property string buttonBorderColor: "#2D2D2D"  // Surface variant
    property string buttonBackgroundColor: "#2D2D2D"  // Surface variant
    property bool buttonBorderShadow: true
    property bool onTop: true
    property string iconColor: "#90CAF9"  // Primary light
    property string iconPressedColor: "#64B5F6"  // Primary medium
  }

  Item {
    id: catppuccin

    // Catppuccin Mocha color palette
    property string barBgColor: "#aa1E1E2E"  // Base
    property string buttonBorderColor: "#313244"  // Surface0
    property string buttonBackgroundColor: "#313244"  // Surface0
    property bool buttonBorderShadow: true
    property bool onTop: true
    property string iconColor: "#89B4FA"  // Blue
    property string iconPressedColor: "#74C7EC"  // Sapphire
  }

  Item {
    id: orange

    // Orange color palette
    property string barBgColor: '#61fc4700'  // Nord0 - Polar Night
    property string buttonBorderColor: "#4C566A"  // Nord3 - Polar Night
    property string buttonBackgroundColor: "#3D4550"
    property bool buttonBorderShadow: true
    property bool onTop: true
    property string iconColor: "#88C0D0"  // Nord7 - Frost
    property string iconPressedColor: "#81A1C1"  // Nord9 - Frost
    property string wsBgColor: '#ab000000'
    property string wsActiveColor: '#f53d00'
    property string activewsBgColor: '#8d882f14'
  }

  Item {
    id: matugen

      // Pick a random surface color on load
    property color _randomBg: {
      var options = [
        colors.surface_dim,
        colors.surface_variant,
        colors.surface_bright,
        colors.on_secondary,
        colors.on_secondary_fixed,
        colors.on_secondary_fixed_variant,
        colors.secondary_container,
        colors.source_color
      ]
      return options[Math.floor(Math.random() * options.length)]
    }

    property color barBgColor: Qt.rgba(
      _randomBg.r,
      _randomBg.g,
      _randomBg.b,
      0.8  // your desired opacity
    )
  // ... rest of your properties

    property string buttonBorderColor: "#4C566A"  // Nord3 - Polar Night
    property string buttonBackgroundColor: "#3D4550"
    property bool buttonBorderShadow: true
    property bool onTop: true
    property string iconColor: "#88C0D0"  // Nord7 - Frost
    property string iconPressedColor: "#81A1C1"  // Nord9 - Frost
    property string wsBgColor: colors.surface_container_low
    property string wsActiveColor: colors.on_secondary_container
    property string wsActiveTextColor: colors.on_secondary
    property string wsOccupiedTextColor: colors.secondary_fixed_dim
    property string wsEmptyTextColor: colors.outline_variant
    property string activewsBgColor: '#8d882f14'
    property string barText: colors.on_secondary_container
    property string barFontColor: colors.on_secondary_container
    property string barFontShadow: colors.shadow
    property string barHover: colors.secondary_fixed_dim
    property string notiAlert: colors.error
    property string notiColor: colors.error

    // Calendar Widget
    property string calBg: colors.surface_container_low
    property string calInBg: colors.on_secondary_fixed
    property string calBorder: colors.secondary_fixed
    property string highBg: colors.secondary_fixed_dim
    property string highText: colors.on_secondary_fixed
    property string dayText: colors.on_secondary_container
    property string monthText: colors.tertiary_fixed_dim
    property string clockText: colors.on_surface
    property string mainTextPri: colors.on_primary_container 
    property string mainTextSec: colors.on_tertiary_container
    property string calText: colors.on_tertiary_container
    property string strokeStyle: colors.surface_bright
    property string perEightyPlus: colors.on_error
    property string perEightyMinus: colors.tertiary_container

    // Audio Player
    property string audioAccent: colors.secondary
    property string songFont: colors.tertiary_fixed
    property string artistFont: colors.primary_fixed
    property string albumFont: colors.tertiary_fixed_dim

    // Clock Widget
    property string dayShadowColor: colors.secondary_fixed
    property string dayColorTop: colors.tertiary_fixed
    property string dayColorMid: colors.on_secondary_fixed_variant
    property string dayColorBot: colors.on_secondary_fixed
    property string dateFontColor: colors.secondary_container
    property string dateShadowColor: colors.on_secondary_container
  }

}



