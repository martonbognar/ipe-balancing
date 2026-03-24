class CacheModel:
    def __init__(self):
        self.addresses = [
            [-1, -1],
            [-1, -1],
        ]
        self.replace_next = [0, 0]

    @staticmethod
    def get_set_index(address):
        return (address >> 3) % 2

    def handle_load(self, address) -> bool:
        set_index = self.get_set_index(address)
        tag = address >> 4

        # print(f'Debug info: cache load {tag}')

        if self.addresses[set_index][0] == tag:
            self.replace_next[set_index] = 1
            return True
        elif self.addresses[set_index][1] == tag:
            self.replace_next[set_index] = 0
            return True
        else:
            # Cache miss, replace the next block
            replace_index = self.replace_next[set_index]
            self.addresses[set_index][replace_index] = tag
            self.replace_next[set_index] = 1 - self.replace_next[set_index]  # Toggle between 0 and 1
            return False

    def handle_store(self, address) -> None:
        set_index = self.get_set_index(address)
        tag = address >> 4

        if self.addresses[set_index][0] == tag:
            self.addresses[set_index][0] = -1  # Invalidate the block
        elif self.addresses[set_index][1] == tag:
            self.addresses[set_index][1] = -1  # Invalidate the block

    def fetch_instruction(self, address, size) -> [bool]:
        # print(f'Debug info: instruction fetch {hex(address)} ({size})')
        return [self.handle_load(offset) for offset in range(address, address + ((size - 1) * 2) + 4, 2)]

    def fetch_jump(self, address, target, condition) -> [bool]:
        # print(f'Debug info: branch fetch {address} ({target}) with {condition}')
        if condition:
            return [self.handle_load(address), self.handle_load(address + 2), self.handle_load(target), self.handle_load(target + 2)]
        else:
            return [self.handle_load(address), self.handle_load(address + 2), self.handle_load(target), self.handle_load(address + 4)]
