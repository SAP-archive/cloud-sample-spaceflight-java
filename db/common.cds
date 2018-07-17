namespace common;

abstract entity Managed {
    key ID        : UUID;
}

abstract entity Named {
    Name      : String(100);
}
