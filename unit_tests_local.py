#!/usr/bin/python3

import logging
import unittest
import sys
import os

import libpermian.plugins

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG, filename="test_debug.log")
    loader = unittest.TestLoader()

    libpermian.plugins.load()
    tests = loader.discover(pattern="test*.py", start_dir="libpermian.plugins.kickstart_test")

    runner = unittest.runner.TextTestRunner(verbosity=1)
    result = runner.run(tests)
    if not result.wasSuccessful():
        sys.exit(2)
