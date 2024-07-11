import copy


class Fighter:

    def __init__(self, name):
        self.id = 1
        self.name = name
        self.items = self.get_items()
        self.ancestor = None

    @staticmethod
    def get_items():
        return ('Longsword', 'Chainmail')
    
    def __copy__(self):

        clone = self.__class__(self.name)
        clone.__dict__.update(self.__dict__)
        clone.id += 1
        clone.ancestor = self
        return clone
    
    def __deepcopy__(self, memo=None):
        
        if memo is None:
            memo = dict()

        clone_items = list(self.items)

        clone = self.__class__(self.name)
        clone.__dict__.update(self.__dict__)
        clone.id += 1
        clone.items = clone_items
        clone.ancestor = self
        print(id(self.items), id(clone.items))
        return clone


class Gunner:

    def __init__(self, name):
        self.id = 1
        self.name = name
        self.items = self.get_items()
        self.ancestor = None

    @staticmethod
    def get_items():
        return ('Revolver', 'Scalemail')
    
    def __copy__(self):

        clone = self.__class__(self.name)
        clone.__dict__.update(self.__dict__)
        clone.id += 1
        clone.ancestor = self
        return clone
    
    def __deepcopy__(self, memo=None):
        
        if memo is None:
            memo = dict()

        clone_items = list(self.items)

        clone = self.__class__(self.name)
        clone.__dict__.update(self.__dict__)
        clone.id += 1
        clone.items = clone_items
        clone.ancestor = self
        return clone
    
if __name__ == '__main__':

    fighter_a = Fighter('Barbarosa')
    gunner_a = Gunner('Linda')

    fighter_a_shallow = copy.copy(fighter_a)
    gunner_a_shallow = copy.copy(gunner_a)

    fighter_a_deep = copy.deepcopy(fighter_a_shallow)
    gunner_a_deep = copy.deepcopy(gunner_a_shallow)

    # Showing memory addresses of characters. In each case, either copy or deepcopy are unsuitable.
    print('Character', id(fighter_a))
    print('Items', id(fighter_a.items))
    print('Ancestor', id(fighter_a.ancestor))

    # Shallow copy will not change the pointer reference of items. Thus if changing the items of the copied object, the items of the original object
    # will also change. This is not desirable.
    print('Character', id(fighter_a_shallow))
    print('Items', id(fighter_a_shallow.items))
    print('Ancestor', id(fighter_a_shallow.ancestor))

    print('Items pointer changed:', fighter_a.items != fighter_a_shallow.items)
    
    # Deepcopy will change the items object in memory. This way, each new copy has it's own list of items that can be changed independently of each
    # other.
    print('Character', id(fighter_a_deep))
    print('Items', id(fighter_a_deep.items))
    print('Ancestor', id(fighter_a_deep.ancestor))

    print('Items pointer changed:', fighter_a_shallow.items != fighter_a_deep.items)
