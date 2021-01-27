from main import *
import unittest

class ProgramTest(unittest.TestCase):

    def test_1(self): #test for 1 task
        tp = ThreadPool(3)
        t1 = MyTask('t1', lambda: 10 + 10)
        tp.enqueue(t1)
        while True:
            if t1.is_completed():
                break
        tp.dispose()
        self.assertEqual(t1.result(), 20)

    def test_2(self): #test for several tasks
        tp = ThreadPool(3)
        t1 = MyTask('t1', lambda: 10 + 10)
        tp.enqueue(t1)
        t2 = MyTask('t2', lambda: 9 - 7)
        tp.enqueue(t2)
        t3 = MyTask('t3', lambda: 6 * 8)
        tp.enqueue(t3)
        while True:
            if all(x.is_completed() for x in [t1, t2, t3]):
                break
        tp.dispose()
        self.assertEqual(t1.result() + t2.result() + t3.result(), 70)

    def test_3(self): #test for tasks number > threads number
        tp = ThreadPool(2)
        t1 = MyTask('t1', lambda: str(1))
        tp.enqueue(t1)
        t2 = MyTask('t2', lambda: str(2))
        tp.enqueue(t2)
        t3 = MyTask('t3', lambda: str(3))
        tp.enqueue(t3)
        t4 = MyTask('t4', lambda: str(4))
        tp.enqueue(t4)
        time.sleep(2)
        while True:
            if all(x.is_completed() for x in [t1, t2, t3, t4]):
                break
        tp.dispose()
        self.assertEqual(t1.result() + t2.result() + t3.result() + t4.result(), '1234')

    def test_4(self): #test continue_with for 1 step
        tp = ThreadPool(2)
        t1 = MyTask('t1', lambda: 10 + 10)
        tp.enqueue(t1)
        t2 = t1.continue_with('t2', lambda x: 5 * x)
        tp.enqueue(t2)
        while True:
            if all(x.is_completed() for x in [t1, t2]):
                break
        tp.dispose()
        self.assertEqual(t2.result(), 100)

    def test_5(self): #test continue_with for 2 steps
        tp = ThreadPool(3)
        t1 = MyTask('t1', lambda: 10 + 10)
        tp.enqueue(t1)
        t2 = t1.continue_with('t2', lambda x: 5 * x)
        tp.enqueue(t2)
        t3 = t2.continue_with('t3', lambda x: 'Hello, ' + str(x))
        tp.enqueue(t3)
        while True:
            if all(x.is_completed() for x in [t1, t2, t3]):
                break
        tp.dispose()
        self.assertEqual(t3.result(), 'Hello, 100')

    def test_6(self): #test that threads number is correct
        tp = ThreadPool(5)
        cnt = 0
        threads = threading.enumerate()
        for th in threads:
            if isinstance(th, MyThread):
                cnt += 1
        tp.dispose()
        self.assertEqual(cnt, 5)

if __name__ == '__main__':
    unittest.main()
