from enum import Enum


class AnalysisResult(Enum):
    SUCCESS = 0
    INFORMATION_LEAK = 1        # leak via return value(?)
    TIMING_LEAK = 2             # different start-to-end timing
    LOOP_ON_SECRET_DATA = 3     # secret-dependent loop condition
    NEMESIS_VULNERABILITY = 4   # different instruction counts or latencies
    DMA_VULNERABILITY = 5       # different instruction rom/ram/mmio access trace
    MPU_VULNERABILITY = 6       # different MPU region
    CACHE_VULNERABILITY = 7     # different cache access pattern

    def __str__(self) -> str:
        strs = {
            self.SUCCESS: "Success",
            self.INFORMATION_LEAK: "Architectural 🗲",
            self.TIMING_LEAK: "Timing 🗲",
            self.LOOP_ON_SECRET_DATA: "Loop on secret 🗲",
            self.NEMESIS_VULNERABILITY: "Nemesis 🗲",
            self.DMA_VULNERABILITY: "DMA 🗲",
            self.MPU_VULNERABILITY: "MPU 🗲",
            self.CACHE_VULNERABILITY: "Cache 🗲"
        }
        return strs[self]
