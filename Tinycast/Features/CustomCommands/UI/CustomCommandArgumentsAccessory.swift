import SwiftUI

/// A custom command's inline fields in root search, keyed by `$n` rather than by name.
@MainActor
enum CustomCommandArgumentsAccessory {
    /// Nil for a command that takes no arguments.
    static func make(
        command: CustomCommand?,
        vm: PaletteState,
        metrics: InterfaceMetrics,
        focus: FocusState<String?>.Binding,
        onOpenOptions: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) -> PaletteHeaderAccessory? {
        guard let command, !command.arguments.isEmpty else { return nil }
        let arguments = command.arguments.enumerated().map { index, argument in
            InlineArgument(
                id: CustomCommandArgument.fieldID(at: index), title: argument.name,
                options: argument.options.map(\.title), isOptional: argument.isOptional)
        }
        let value = { (id: String) in binding(command: command, id: id, vm: vm) }
        let firstOwed = {
            arguments.first { !$0.isOptional && value($0.id).wrappedValue.isEmpty }?.id
        }
        return PaletteHeaderAccessory(
            width: InlineArgumentFields.totalWidth(for: arguments, hasIcon: true, metrics: metrics),
            fieldNames: arguments.map(\.id),
            firstIncompleteField: firstOwed(),
            optionsMenu: { id in
                guard let argument = dropdown(command, fieldID: id) else { return nil }
                return menu(for: argument, value: value(id))
            },
            optionsAnchor: { id in
                vm.argumentFrames[PaletteState.argumentKey(command.entryID, id)]
            },
            // Identity per row, so "which fields were left unanswered" starts clean on the next one.
            view: AnyView(
                InlineArgumentFields(
                    arguments: arguments, symbol: command.symbol, value: value, focused: focus,
                    openOptions: onOpenOptions,
                    // Raycast's rule: ↵ never runs short, it moves to the required field instead.
                    onSubmit: {
                        guard let owed = firstOwed() else { return onSubmit() }
                        focus.wrappedValue = owed
                    },
                    onFrame: { id, frame in
                        vm.argumentFrames[PaletteState.argumentKey(command.entryID, id)] = frame
                    }
                )
                .id(command.entryID))
        )
    }

    /// Stored values keyed by field; a dropdown's stored title is swapped for the option's value.
    static func values(for command: CustomCommand, vm: PaletteState) -> [String: String] {
        var values: [String: String] = [:]
        for index in command.arguments.indices {
            let id = CustomCommandArgument.fieldID(at: index)
            let stored = vm.commandArguments[PaletteState.argumentKey(command.entryID, id)] ?? ""
            let sent = command.arguments[index].scriptValue(forTitle: stored)
            if !sent.isEmpty { values[id] = sent }
        }
        return values
    }

    /// The dropdown argument a field id belongs to, or nil for a typed one.
    private static func dropdown(
        _ command: CustomCommand, fieldID: String
    ) -> CustomCommandArgument? {
        guard let index = command.arguments.indices.first(where: {
            CustomCommandArgument.fieldID(at: $0) == fieldID
        }) else { return nil }
        let argument = command.arguments[index]
        return argument.isDropdown ? argument : nil
    }

    private static func menu(
        for argument: CustomCommandArgument, value: Binding<String>
    ) -> PopoverMenuContent {
        PopoverMenuContent(
            header: argument.name,
            items: argument.options.map { option in
                PopoverMenuItem(
                    title: option.title,
                    icon: value.wrappedValue == option.title ? .symbol("checkmark") : .blank
                ) { value.wrappedValue = option.title }
            })
    }

    private static func binding(
        command: CustomCommand, id: String, vm: PaletteState
    ) -> Binding<String> {
        let key = PaletteState.argumentKey(command.entryID, id)
        return Binding(get: { vm.commandArguments[key] ?? "" }, set: { vm.commandArguments[key] = $0 })
    }
}
