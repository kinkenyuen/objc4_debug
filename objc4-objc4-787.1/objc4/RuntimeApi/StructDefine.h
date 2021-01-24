//
//  StructDefine.h
//  objc
//
//  Created by jianqin_ruan on 2021/1/24.
//

#ifndef StructDefine_h
#define StructDefine_h

#define ASSERT(x) assert(x)

struct ivar_t {
    int32_t *offset;
    const char *name;
    const char *type;
    // alignment is sometimes -1; use alignment() instead
    uint32_t alignment_raw;
    uint32_t size;
};

struct property_t {
    const char *name;
    const char *attributes;
};

/*Method*/
class nocopy_t {
  private:
    nocopy_t(const nocopy_t&) = delete;
    const nocopy_t& operator=(const nocopy_t&) = delete;
  protected:
    constexpr nocopy_t() = default;
    ~nocopy_t() = default;
};

template <typename T>
struct RelativePointer: nocopy_t {
    int32_t offset;

    T get() const {
        uintptr_t base = (uintptr_t)&offset;
        uintptr_t signExtendedOffset = (uintptr_t)(intptr_t)offset;
        uintptr_t pointer = base + signExtendedOffset;
        return (T)pointer;
    }
};

struct method_t {
    static const uint32_t smallMethodListFlag = 0x80000000;

    method_t(const method_t &other) = delete;

    // The representation of a "big" method. This is the traditional
    // representation of three pointers storing the selector, types
    // and implementation.
    struct big {
        SEL name;
        const char *types;
        IMP imp;
    };
    
private:
    bool isSmall() const {
        return ((uintptr_t)this & 1) == 1;
    }
    
    struct small {
        RelativePointer<SEL *> name;
        RelativePointer<const char *> types;
        RelativePointer<IMP> imp;
    };

    small &small() const {
        ASSERT(isSmall());
        return *(struct small *)((uintptr_t)this & ~(uintptr_t)1);
    }
    
//    IMP remappedImp(bool needsLock) const;
//    void remapImp(IMP imp);
//    objc_method_description *getSmallDescription() const;
    
public:
    static const auto bigSize = sizeof(struct big);
    static const auto smallSize = sizeof(struct small);
    
    struct pointer_modifier {
        template <typename ListType>
        static method_t *modify(const ListType &list, method_t *ptr) {
            if (list.flags() & smallMethodListFlag)
                return (method_t *)((uintptr_t)ptr | 1);
            return ptr;
        }
    };
    
    big &big() const {
        ASSERT(!isSmall());
        return *(struct big *)this;
    }
    
    SEL &name() const {
        return isSmall() ? *small().name.get() : big().name;
    }
    const char *types() const {
        return isSmall() ? small().types.get() : big().types;
    }
    IMP imp(bool needsLock) const {
//        if (isSmall()) {
//            IMP imp = remappedImp(needsLock);
//            if (!imp)
//                imp = ptrauth_sign_unauthenticated(small().imp.get(),
//                                                   ptrauth_key_function_pointer, 0);
//            return imp;
//        }
        return big().imp;
    }
    
//    void setImp(IMP imp) {
//        if (isSmall()) {
//            remapImp(imp);
//        } else {
//            big().imp = imp;
//        }
//
//    }

//    objc_method_description *getDescription() const {
//        return isSmall() ? getSmallDescription() : (struct objc_method_description *)this;
//    }

//    struct SortBySELAddress :
//    public std::binary_function<const struct method_t::big&,
//                                const struct method_t::big&, bool>
//    {
//        bool operator() (const struct method_t::big& lhs,
//                         const struct method_t::big& rhs)
//        { return lhs.name < rhs.name; }
//    };

    method_t &operator=(const method_t &other) {
        ASSERT(!isSmall());
        big().name = other.name();
        big().types = other.types();
        big().imp = other.imp(false);
        return *this;
    }
};


#endif /* StructDefine_h */
