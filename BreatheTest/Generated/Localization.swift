// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum BreatheExercise {
    internal enum Button {
      /// TAP HERE TO BREATHE
      internal static let start = L10n.tr("Localizable", "breathe_exercise.button.start")
    }
    internal enum Label {
      /// Remaining
      internal static let remainingTime = L10n.tr("Localizable", "breathe_exercise.label.remaining_time")
    }
  }

  internal enum BreathePhase {
    internal enum Kind {
      /// EXHALE
      internal static let exhale = L10n.tr("Localizable", "breathe_phase.kind.exhale")
      /// HOLD
      internal static let hold = L10n.tr("Localizable", "breathe_phase.kind.hold")
      /// INHALE
      internal static let inhale = L10n.tr("Localizable", "breathe_phase.kind.inhale")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
