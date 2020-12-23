@enum Status COMPLETE ACTIVE
using UUIDs
RNG = UUIDs.MersenneTwister(1234)

struct Todo
    title::String
    status::Status
    uuid::UUID
    Todo(title) = new(title, ACTIVE, UUIDs.uuid4(RNG))
end

