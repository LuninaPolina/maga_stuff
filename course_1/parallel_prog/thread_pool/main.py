import threading, typing, random, time

class MyThread(threading.Thread):

    def __init__(self, num, args):
        super(MyThread, self).__init__()
        self.num = num
        self.args = args

    def run(self):
        while self.args.canc_token == False or any(len(x) > 0 for x in self.args.queues):
            task = None
            with self.args.mutex:
                if len(self.args.queues[self.num]) > 0: #search for task in threads own queue
                    task = self.args.queues[self.num][0]
                    self.args.queues[self.num].pop(0)
                    self.args.output_log += 'MyThread-' + str(self.num) + ' took task ' + task.name + '\n'
                else: #steal task from some other thread queue if exists
                    for i in range(len(self.args.queues)):
                        if len(self.args.queues[i]) > 0:
                            task = self.args.queues[i][0]
                            self.args.queues[i].pop(0)
                            self.args.output_log += 'MyThread-' + str(self.num) + ' stole task ' + task.name + ' from MyThread-' + str(i) + '\n'
                            break
            if task is not None:
                try:
                    task.solve()
                except Exception as e:
                    self.args.exception = True, e                 
                self.args.output_log += 'MyThread-' + str(self.num) + ' solved task ' + task.name + '; result is ' + str(task.result()) + '\n'
            time.sleep(random.randint(1, 3))

    def join(self):
        super(MyThread, self).join()
        if self.args.exception[0]:
            raise self.args.exception[1]


class ThreadPool:

    class Args:

        def __init__(self, n):
            self.mutex = threading.Lock() #for accessing the queue
            self.queues = [[] for i in range(n)] #each thread has its personal queue
            self.canc_token = False #for stopping the pool
            self.output_log = '' #for printing
            self.exception = (False, None) #for exceptions catching


    def __init__(self, n):
        self.args = ThreadPool.Args(n)
        self.threads = [MyThread(i, self.args) for i in range(n)]
        for th in self.threads:
           th.start()

    def enqueue(self, task):
        if not self.args.canc_token:
            with (self.args.mutex): #add task to the shortest of threads queues
                idx = self.args.queues.index(min(self.args.queues, key=len))
                self.args.queues[idx].append(task)
                self.args.output_log += 'Task ' + task.name + ' added to queue for MyThread-' + str(idx) + '\n'

    def dispose(self):
        self.args.canc_token = True
        for th in self.threads:
            th.join()
            self.args.output_log += 'MyThread-' + str(th.num) + ' is stopped\n'
        self.args.output_log += 'ThreadPool is disposed\n'

            
class MyTask:
    
    def __init__(self, name, func):
        self.name = name
        self.func = func
        self.__completed = False
        self.__res = None

    def is_completed(self):
        return self.__completed
    
    def result(self):
        return self.__res
    
    def continue_with(self, name, func):
        while not self.is_completed():
            time.sleep(1)
        return MyTask(name, lambda: func(self.result()))

    def solve(self):
        self.__res = self.func()
        self.__completed = True

           
def demonstration():
    print('Simple demo for 3 threads and 5 tasks\n')
    print('Task1 -> 1 + 1')
    print('Task2 -> 2 * 2')
    print('Task3 -> Hello + str(Task2)')
    print('Task4 -> Task2 + 2')
    print('Task5 -> Task4 - 1\n')
    tp = ThreadPool(3)
    t1 = MyTask('t1', lambda: 1 + 1)
    tp.enqueue(t1)
    t2 = MyTask('t2', lambda: 2 * 2)
    tp.enqueue(t2)
    t3 = t2.continue_with('t3', lambda x: 'Hello, ' + str(x))
    tp.enqueue(t3)
    t4 = t2.continue_with('t4', lambda x: x + 2)
    tp.enqueue(t4)
    t5 = t4.continue_with('t5', lambda x: x - 1)
    tp.enqueue(t5)
    print('...\nWait\n...\n')
    time.sleep(5)
    tp.dispose()  
    print(tp.args.output_log)


if __name__ == '__main__':
    demonstration()
