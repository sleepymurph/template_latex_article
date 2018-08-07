#!/usr/bin/env python3

import unittest
import datetime

import numpy as np

import plot_multimeter_data as pmm

class ParseTimestampTest(unittest.TestCase):

    def test_parsetimestamp(self):
        self.assertEqual(
            pmm.parsetimestamp(b"00:14:57:997"),
            np.datetime64("1900-01-01T00:14:57.997"))
