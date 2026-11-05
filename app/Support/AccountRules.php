<?php

namespace App\Support;

final class AccountRules
{
    public static function email(): array
    {
        return ['bail', 'required', 'string', 'max:190', 'email:rfc', 'regex:/\A[^@\s]+@gmail\.com\z/i'];
    }

    public static function password(bool $required = true): array
    {
        return [$required ? 'required' : 'nullable', 'string', 'min:8', 'max:72', 'regex:/[A-Z]/', 'regex:/[0-9]/'];
    }
}
