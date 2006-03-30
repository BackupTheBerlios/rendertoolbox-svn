
/*  A Bison parser, made from core/pbrtparse.y
    by GNU Bison version 1.28  */

#define YYBISON 1  /* Identify Bison output.  */

#define	STRING	257
#define	ID	258
#define	NUM	259
#define	LBRACK	260
#define	RBRACK	261
#define	ACCELERATOR	262
#define	AREALIGHTSOURCE	263
#define	ATTRIBUTEBEGIN	264
#define	ATTRIBUTEEND	265
#define	CAMERA	266
#define	CONCATTRANSFORM	267
#define	COORDINATESYSTEM	268
#define	COORDSYSTRANSFORM	269
#define	FILM	270
#define	IDENTITY	271
#define	LIGHTSOURCE	272
#define	LOOKAT	273
#define	MATERIAL	274
#define	OBJECTBEGIN	275
#define	OBJECTEND	276
#define	OBJECTINSTANCE	277
#define	PIXELFILTER	278
#define	REVERSEORIENTATION	279
#define	ROTATE	280
#define	SAMPLER	281
#define	SCALE	282
#define	SEARCHPATH	283
#define	SHAPE	284
#define	SURFACEINTEGRATOR	285
#define	TEXTURE	286
#define	TRANSFORMBEGIN	287
#define	TRANSFORMEND	288
#define	TRANSFORM	289
#define	TRANSLATE	290
#define	VOLUME	291
#define	VOLUMEINTEGRATOR	292
#define	WORLDBEGIN	293
#define	WORLDEND	294
#define	HIGH_PRECEDENCE	295

#line 11 "core/pbrtparse.y"

#include "api.h"
#include "pbrt.h"
#include "paramset.h"
#include <stdarg.h>

extern int yylex( void );
int line_num = 0;
string current_file;

#define YYMAXDEPTH 100000000

void yyerror( char *str ) {
	Severe( "Parsing error: %s", str);
}

void ParseError( const char *format, ... ) PRINTF_FUNC;

void ParseError( const char *format, ... ) {
	char error[4096];
	va_list args;
	va_start( args, format );
	vsprintf( error, format, args );
	yyerror(error);
	va_end( args );
}

int cur_paramlist_allocated = 0;
int cur_paramlist_size = 0;
const char **cur_paramlist_tokens = NULL;
void **cur_paramlist_args = NULL;
int *cur_paramlist_sizes = NULL;
bool *cur_paramlist_texture_helper = NULL;

#define CPS cur_paramlist_size
#define CPT cur_paramlist_tokens
#define CPA cur_paramlist_args
#define CPTH cur_paramlist_texture_helper
#define CPSZ cur_paramlist_sizes

typedef struct ParamArray {
	int element_size;
	int allocated;
	int nelems;
	void *array;
} ParamArray;

ParamArray *cur_array = NULL;
bool array_is_single_string = false;

#define NA(r) ((float *) r->array)
#define SA(r) ((const char **) r->array)

void AddArrayElement( void *elem ) {
	if (cur_array->nelems >= cur_array->allocated) {
		cur_array->allocated = 2*cur_array->allocated + 1;
		cur_array->array = realloc( cur_array->array,
			cur_array->allocated*cur_array->element_size );
	}
	char *next = ((char *)cur_array->array) + cur_array->nelems *
		cur_array->element_size;
	memcpy( next, elem, cur_array->element_size );
	cur_array->nelems++;
}

ParamArray *ArrayDup( ParamArray *ra )
{
	ParamArray *ret = new ParamArray;
	ret->element_size = ra->element_size;
	ret->allocated = ra->allocated;
	ret->nelems = ra->nelems;
	ret->array = malloc(ra->nelems * ra->element_size);
	memcpy( ret->array, ra->array, ra->nelems * ra->element_size );
	return ret;
}

void ArrayFree( ParamArray *ra )
{
	free(ra->array);
	delete ra;
}

void FreeArgs()
{
	for (int i = 0; i < cur_paramlist_size; ++i)
		delete[] ((char *)cur_paramlist_args[i]);
}

static bool VerifyArrayLength( ParamArray *arr, int required,
	const char *command ) {
	if (arr->nelems != required) {
		ParseError( "%s requires a(n) %d element array!", command, required);
		return false;
	}
	return true;
}
enum { PARAM_TYPE_INT, PARAM_TYPE_BOOL, PARAM_TYPE_FLOAT, PARAM_TYPE_POINT,
	PARAM_TYPE_VECTOR, PARAM_TYPE_NORMAL, PARAM_TYPE_COLOR,
	PARAM_TYPE_STRING, PARAM_TYPE_TEXTURE };
static void InitParamSet(ParamSet &ps, int count, const char **tokens,
	void **args, int *sizes, bool *texture_helper);
static bool lookupType(const char *token, int *type, string &name);
#define YYPRINT(file, type, value)  \
{ \
	if ((type) == ID || (type) == STRING) \
		fprintf ((file), " %s", (value).string); \
	else if ((type) == NUM) \
		fprintf ((file), " %f", (value).num); \
}

#line 122 "core/pbrtparse.y"
typedef union {
char string[1024];
float num;
ParamArray *ribarray;
} YYSTYPE;
#ifndef YYDEBUG
#define YYDEBUG 1
#endif

#include <stdio.h>

#ifndef __cplusplus
#ifndef __STDC__
#define const
#endif
#endif



#define	YYFINAL		124
#define	YYFLAG		-32768
#define	YYNTBASE	42

#define YYTRANSLATE(x) ((unsigned)(x) <= 295 ? yytranslate[x] : 63)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     1,     3,     4,     5,     6,
     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,
    27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
    37,    38,    39,    40,    41
};

#if YYDEBUG != 0
static const short yyprhs[] = {     0,
     0,     2,     3,     4,     5,     7,     9,    11,    13,    18,
    21,    24,    26,    29,    31,    33,    38,    41,    44,    46,
    49,    52,    53,    56,    57,    60,    63,    65,    69,    73,
    75,    77,    81,    84,    87,    90,    94,    96,   100,   111,
   115,   118,   120,   123,   127,   129,   135,   139,   144,   147,
   151,   155,   161,   163,   165,   168,   173,   177,   181,   183
};

static const short yyrhs[] = {    61,
     0,     0,     0,     0,    47,     0,    52,     0,    48,     0,
    49,     0,    43,     6,    50,     7,     0,    43,    51,     0,
    50,    51,     0,    51,     0,    44,     3,     0,    53,     0,
    54,     0,    43,     6,    55,     7,     0,    43,    56,     0,
    55,    56,     0,    56,     0,    45,     5,     0,    58,    59,
     0,     0,    60,    59,     0,     0,     3,    46,     0,    61,
    62,     0,    62,     0,     8,     3,    57,     0,     9,     3,
    57,     0,    10,     0,    11,     0,    12,     3,    57,     0,
    13,    52,     0,    14,     3,     0,    15,     3,     0,    16,
     3,    57,     0,    17,     0,    18,     3,    57,     0,    19,
     5,     5,     5,     5,     5,     5,     5,     5,     5,     0,
    20,     3,    57,     0,    21,     3,     0,    22,     0,    23,
     3,     0,    24,     3,    57,     0,    25,     0,    26,     5,
     5,     5,     5,     0,    27,     3,    57,     0,    28,     5,
     5,     5,     0,    29,     3,     0,    30,     3,    57,     0,
    31,     3,    57,     0,    32,     3,     3,     3,    57,     0,
    33,     0,    34,     0,    35,    53,     0,    36,     5,     5,
     5,     0,    38,     3,    57,     0,    37,     3,    57,     0,
    39,     0,    40,     0
};

#endif

#if YYDEBUG != 0
static const short yyrline[] = { 0,
   144,   148,   158,   163,   168,   172,   177,   181,   187,   192,
   196,   199,   203,   209,   213,   218,   223,   227,   230,   234,
   240,   244,   249,   252,   256,   274,   277,   281,   288,   295,
   299,   303,   310,   316,   320,   324,   331,   335,   342,   346,
   353,   357,   361,   365,   372,   376,   380,   387,   391,   395,
   402,   409,   416,   420,   424,   430,   434,   441,   448,   452
};
#endif


#if YYDEBUG != 0 || defined (YYERROR_VERBOSE)

static const char * const yytname[] = {   "$","error","$undefined.","STRING",
"ID","NUM","LBRACK","RBRACK","ACCELERATOR","AREALIGHTSOURCE","ATTRIBUTEBEGIN",
"ATTRIBUTEEND","CAMERA","CONCATTRANSFORM","COORDINATESYSTEM","COORDSYSTRANSFORM",
"FILM","IDENTITY","LIGHTSOURCE","LOOKAT","MATERIAL","OBJECTBEGIN","OBJECTEND",
"OBJECTINSTANCE","PIXELFILTER","REVERSEORIENTATION","ROTATE","SAMPLER","SCALE",
"SEARCHPATH","SHAPE","SURFACEINTEGRATOR","TEXTURE","TRANSFORMBEGIN","TRANSFORMEND",
"TRANSFORM","TRANSLATE","VOLUME","VOLUMEINTEGRATOR","WORLDBEGIN","WORLDEND",
"HIGH_PRECEDENCE","start","array_init","string_array_init","num_array_init",
"array","string_array","real_string_array","single_element_string_array","string_list",
"string_list_entry","num_array","real_num_array","single_element_num_array",
"num_list","num_list_entry","paramlist","paramlist_init","paramlist_contents",
"paramlist_entry","ri_stmt_list","ri_stmt", NULL
};
#endif

static const short yyr1[] = {     0,
    42,    43,    44,    45,    46,    46,    47,    47,    48,    49,
    50,    50,    51,    52,    52,    53,    54,    55,    55,    56,
    57,    58,    59,    59,    60,    61,    61,    62,    62,    62,
    62,    62,    62,    62,    62,    62,    62,    62,    62,    62,
    62,    62,    62,    62,    62,    62,    62,    62,    62,    62,
    62,    62,    62,    62,    62,    62,    62,    62,    62,    62
};

static const short yyr2[] = {     0,
     1,     0,     0,     0,     1,     1,     1,     1,     4,     2,
     2,     1,     2,     1,     1,     4,     2,     2,     1,     2,
     2,     0,     2,     0,     2,     2,     1,     3,     3,     1,
     1,     3,     2,     2,     2,     3,     1,     3,    10,     3,
     2,     1,     2,     3,     1,     5,     3,     4,     2,     3,
     3,     5,     1,     1,     2,     4,     3,     3,     1,     1
};

static const short yydefact[] = {     0,
     0,     0,    30,    31,     0,     2,     0,     0,     0,    37,
     0,     0,     0,     0,    42,     0,     0,    45,     0,     0,
     0,     0,     0,     0,     0,    53,    54,     2,     0,     0,
     0,    59,    60,     1,    27,    22,    22,    22,     4,    33,
    14,    15,    34,    35,    22,    22,     0,    22,    41,    43,
    22,     0,    22,     0,    49,    22,    22,     0,     0,    55,
     0,    22,    22,    26,    28,    24,    29,    32,     4,     0,
    17,    36,    38,     0,    40,    44,     0,    47,     0,    50,
    51,     0,     0,    58,    57,     2,    21,    24,     4,    19,
    20,     0,     0,    48,    22,    56,     3,    25,     5,     7,
     8,     6,    23,    16,    18,     0,    46,    52,     3,     0,
    10,     0,     3,    12,    13,     0,     9,    11,     0,     0,
    39,     0,     0,     0
};

static const short yydefgoto[] = {   122,
    39,   110,    70,    98,    99,   100,   101,   113,   111,    40,
    41,    42,    89,    71,    65,    66,    87,    88,    34,    35
};

static const short yypact[] = {    53,
     4,     9,-32768,-32768,    10,-32768,    12,    14,    15,-32768,
    18,    17,    21,    24,-32768,    25,    26,-32768,    27,    28,
    29,    30,    32,    33,    34,-32768,-32768,-32768,    35,    36,
    38,-32768,-32768,    53,-32768,-32768,-32768,-32768,    39,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,    37,-32768,-32768,-32768,
-32768,    41,-32768,    42,-32768,-32768,-32768,    45,    39,-32768,
    44,-32768,-32768,-32768,-32768,    47,-32768,-32768,-32768,    46,
-32768,-32768,-32768,    48,-32768,-32768,    49,-32768,    50,-32768,
-32768,    54,    51,-32768,-32768,-32768,-32768,    47,    23,-32768,
-32768,    89,    90,-32768,-32768,-32768,    -1,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,    91,-32768,-32768,    92,    56,
-32768,    93,    31,-32768,-32768,    94,-32768,-32768,    95,    96,
-32768,    52,   102,-32768
};

static const short yypgoto[] = {-32768,
   -26,-32768,-32768,-32768,-32768,-32768,-32768,-32768,  -103,   -42,
    75,-32768,-32768,   -66,   -37,-32768,    16,-32768,-32768,    71
};


#define	YYLAST		105


static const short yytable[] = {    67,
    68,    59,    90,    -4,   109,   114,    36,    72,    73,   118,
    75,    37,    38,    76,    43,    78,    44,    45,    80,    81,
    46,    47,   105,    48,    84,    85,    49,    50,    51,   104,
    53,    52,    55,    54,    56,    57,    58,   117,    62,    61,
    63,    74,    90,   102,    69,    77,    79,    82,    83,    86,
    91,   123,    92,    93,    94,    96,    95,   108,   115,    97,
     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,
    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
    31,    32,    33,   106,   107,   112,    -4,   116,   119,   120,
   121,   124,    60,   103,    64
};

static const short yycheck[] = {    37,
    38,    28,    69,     5,     6,   109,     3,    45,    46,   113,
    48,     3,     3,    51,     3,    53,     3,     3,    56,    57,
     3,     5,    89,     3,    62,    63,     3,     3,     3,     7,
     3,     5,     3,     5,     3,     3,     3,     7,     3,     5,
     3,     5,   109,    86,     6,     5,     5,     3,     5,     3,
     5,     0,     5,     5,     5,     5,     3,    95,     3,    86,
     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
    28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
    38,    39,    40,     5,     5,     5,     5,     5,     5,     5,
     5,     0,    28,    88,    34
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "/usr/share/bison.simple"
/* This file comes from bison-1.28.  */

/* Skeleton output parser for bison,
   Copyright (C) 1984, 1989, 1990 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* This is the parser code that is written into each bison parser
  when the %semantic_parser declaration is not specified in the grammar.
  It was written by Richard Stallman by simplifying the hairy parser
  used when %semantic_parser is specified.  */

#ifndef YYSTACK_USE_ALLOCA
#ifdef alloca
#define YYSTACK_USE_ALLOCA
#else /* alloca not defined */
#ifdef __GNUC__
#define YYSTACK_USE_ALLOCA
#define alloca __builtin_alloca
#else /* not GNU C.  */
#if (!defined (__STDC__) && defined (sparc)) || defined (__sparc__) || defined (__sparc) || defined (__sgi) || (defined (__sun) && defined (__i386))
#define YYSTACK_USE_ALLOCA
#include <alloca.h>
#else /* not sparc */
/* We think this test detects Watcom and Microsoft C.  */
/* This used to test MSDOS, but that is a bad idea
   since that symbol is in the user namespace.  */
#if (defined (_MSDOS) || defined (_MSDOS_)) && !defined (__TURBOC__)
#if 0 /* No need for malloc.h, which pollutes the namespace;
	 instead, just don't use alloca.  */
#include <malloc.h>
#endif
#else /* not MSDOS, or __TURBOC__ */
#if defined(_AIX)
/* I don't know what this was needed for, but it pollutes the namespace.
   So I turned it off.   rms, 2 May 1997.  */
/* #include <malloc.h>  */
 #pragma alloca
#define YYSTACK_USE_ALLOCA
#else /* not MSDOS, or __TURBOC__, or _AIX */
#if 0
#ifdef __hpux /* haible@ilog.fr says this works for HPUX 9.05 and up,
		 and on HPUX 10.  Eventually we can turn this on.  */
#define YYSTACK_USE_ALLOCA
#define alloca __builtin_alloca
#endif /* __hpux */
#endif
#endif /* not _AIX */
#endif /* not MSDOS, or __TURBOC__ */
#endif /* not sparc */
#endif /* not GNU C */
#endif /* alloca not defined */
#endif /* YYSTACK_USE_ALLOCA not defined */

#ifdef YYSTACK_USE_ALLOCA
#define YYSTACK_ALLOC alloca
#else
#define YYSTACK_ALLOC malloc
#endif

/* Note: there must be only one dollar sign in this file.
   It is replaced by the list of actions, each action
   as one case of the switch.  */

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	goto yyacceptlab
#define YYABORT 	goto yyabortlab
#define YYERROR		goto yyerrlab1
/* Like YYERROR except do call yyerror.
   This remains here temporarily to ease the
   transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */
#define YYFAIL		goto yyerrlab
#define YYRECOVERING()  (!!yyerrstatus)
#define YYBACKUP(token, value) \
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    { yychar = (token), yylval = (value);			\
      yychar1 = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { yyerror ("syntax error: cannot back up"); YYERROR; }	\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

#ifndef YYPURE
#define YYLEX		yylex()
#endif

#ifdef YYPURE
#ifdef YYLSP_NEEDED
#ifdef YYLEX_PARAM
#define YYLEX		yylex(&yylval, &yylloc, YYLEX_PARAM)
#else
#define YYLEX		yylex(&yylval, &yylloc)
#endif
#else /* not YYLSP_NEEDED */
#ifdef YYLEX_PARAM
#define YYLEX		yylex(&yylval, YYLEX_PARAM)
#else
#define YYLEX		yylex(&yylval)
#endif
#endif /* not YYLSP_NEEDED */
#endif

/* If nonreentrant, generate the variables here */

#ifndef YYPURE

int	yychar;			/*  the lookahead symbol		*/
YYSTYPE	yylval;			/*  the semantic value of the		*/
				/*  lookahead symbol			*/

#ifdef YYLSP_NEEDED
YYLTYPE yylloc;			/*  location data for the lookahead	*/
				/*  symbol				*/
#endif

int yynerrs;			/*  number of parse errors so far       */
#endif  /* not YYPURE */

#if YYDEBUG != 0
int yydebug;			/*  nonzero means print parse trace	*/
/* Since this is uninitialized, it does not stop multiple parsers
   from coexisting.  */
#endif

/*  YYINITDEPTH indicates the initial size of the parser's stacks	*/

#ifndef	YYINITDEPTH
#define YYINITDEPTH 200
#endif

/*  YYMAXDEPTH is the maximum size the stacks can grow to
    (effective only if the built-in stack extension method is used).  */

#if YYMAXDEPTH == 0
#undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
#define YYMAXDEPTH 10000
#endif

/* Define __yy_memcpy.  Note that the size argument
   should be passed with type unsigned int, because that is what the non-GCC
   definitions require.  With GCC, __builtin_memcpy takes an arg
   of type size_t, but it can handle unsigned int.  */

#if __GNUC__ > 1		/* GNU C and GNU C++ define this.  */
#define __yy_memcpy(TO,FROM,COUNT)	__builtin_memcpy(TO,FROM,COUNT)
#else				/* not GNU C or C++ */
#ifndef __cplusplus

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_memcpy (to, from, count)
     char *to;
     char *from;
     unsigned int count;
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#else /* __cplusplus */

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_memcpy (char *to, char *from, unsigned int count)
{
  register char *t = to;
  register char *f = from;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#endif
#endif

#line 217 "/usr/share/bison.simple"

/* The user can define YYPARSE_PARAM as the name of an argument to be passed
   into yyparse.  The argument should have type void *.
   It should actually point to an object.
   Grammar actions can access the variable by casting it
   to the proper pointer type.  */

#ifdef YYPARSE_PARAM
#ifdef __cplusplus
#define YYPARSE_PARAM_ARG void *YYPARSE_PARAM
#define YYPARSE_PARAM_DECL
#else /* not __cplusplus */
#define YYPARSE_PARAM_ARG YYPARSE_PARAM
#define YYPARSE_PARAM_DECL void *YYPARSE_PARAM;
#endif /* not __cplusplus */
#else /* not YYPARSE_PARAM */
#define YYPARSE_PARAM_ARG
#define YYPARSE_PARAM_DECL
#endif /* not YYPARSE_PARAM */

/* Prevent warning if -Wstrict-prototypes.  */
#ifdef __GNUC__
#ifdef YYPARSE_PARAM
int yyparse (void *);
#else
int yyparse (void);
#endif
#endif

int
yyparse(YYPARSE_PARAM_ARG)
     YYPARSE_PARAM_DECL
{
  register int yystate;
  register int yyn;
  register short *yyssp;
  register YYSTYPE *yyvsp;
  int yyerrstatus;	/*  number of tokens to shift before error messages enabled */
  int yychar1 = 0;		/*  lookahead token as an internal (translated) token number */

  short	yyssa[YYINITDEPTH];	/*  the state stack			*/
  YYSTYPE yyvsa[YYINITDEPTH];	/*  the semantic value stack		*/

  short *yyss = yyssa;		/*  refer to the stacks thru separate pointers */
  YYSTYPE *yyvs = yyvsa;	/*  to allow yyoverflow to reallocate them elsewhere */

#ifdef YYLSP_NEEDED
  YYLTYPE yylsa[YYINITDEPTH];	/*  the location stack			*/
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;

#define YYPOPSTACK   (yyvsp--, yyssp--, yylsp--)
#else
#define YYPOPSTACK   (yyvsp--, yyssp--)
#endif

  int yystacksize = YYINITDEPTH;
  int yyfree_stacks = 0;

#ifdef YYPURE
  int yychar;
  YYSTYPE yylval;
  int yynerrs;
#ifdef YYLSP_NEEDED
  YYLTYPE yylloc;
#endif
#endif

  YYSTYPE yyval;		/*  the variable used to return		*/
				/*  semantic values from the action	*/
				/*  routines				*/

  int yylen;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Starting parse\n");
#endif

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss - 1;
  yyvsp = yyvs;
#ifdef YYLSP_NEEDED
  yylsp = yyls;
#endif

/* Push a new state, which is found in  yystate  .  */
/* In all cases, when you get here, the value and location stacks
   have just been pushed. so pushing a state here evens the stacks.  */
yynewstate:

  *++yyssp = yystate;

  if (yyssp >= yyss + yystacksize - 1)
    {
      /* Give user a chance to reallocate the stack */
      /* Use copies of these so that the &'s don't force the real ones into memory. */
      YYSTYPE *yyvs1 = yyvs;
      short *yyss1 = yyss;
#ifdef YYLSP_NEEDED
      YYLTYPE *yyls1 = yyls;
#endif

      /* Get the current used size of the three stacks, in elements.  */
      int size = yyssp - yyss + 1;

#ifdef yyoverflow
      /* Each stack pointer address is followed by the size of
	 the data in use in that stack, in bytes.  */
#ifdef YYLSP_NEEDED
      /* This used to be a conditional around just the two extra args,
	 but that might be undefined if yyoverflow is a macro.  */
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
		 &yyls1, size * sizeof (*yylsp),
		 &yystacksize);
#else
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
		 &yystacksize);
#endif

      yyss = yyss1; yyvs = yyvs1;
#ifdef YYLSP_NEEDED
      yyls = yyls1;
#endif
#else /* no yyoverflow */
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	{
	  yyerror("parser stack overflow");
	  if (yyfree_stacks)
	    {
	      free (yyss);
	      free (yyvs);
#ifdef YYLSP_NEEDED
	      free (yyls);
#endif
	    }
	  return 2;
	}
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;
#ifndef YYSTACK_USE_ALLOCA
      yyfree_stacks = 1;
#endif
      yyss = (short *) YYSTACK_ALLOC (yystacksize * sizeof (*yyssp));
      __yy_memcpy ((char *)yyss, (char *)yyss1,
		   size * (unsigned int) sizeof (*yyssp));
      yyvs = (YYSTYPE *) YYSTACK_ALLOC (yystacksize * sizeof (*yyvsp));
      __yy_memcpy ((char *)yyvs, (char *)yyvs1,
		   size * (unsigned int) sizeof (*yyvsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) YYSTACK_ALLOC (yystacksize * sizeof (*yylsp));
      __yy_memcpy ((char *)yyls, (char *)yyls1,
		   size * (unsigned int) sizeof (*yylsp));
#endif
#endif /* no yyoverflow */

      yyssp = yyss + size - 1;
      yyvsp = yyvs + size - 1;
#ifdef YYLSP_NEEDED
      yylsp = yyls + size - 1;
#endif

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Stack size increased to %d\n", yystacksize);
#endif

      if (yyssp >= yyss + yystacksize - 1)
	YYABORT;
    }

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Entering state %d\n", yystate);
#endif

  goto yybackup;
 yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yychar is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (yychar == YYEMPTY)
    {
#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Reading a token: ");
#endif
      yychar = YYLEX;
    }

  /* Convert token to internal form (in yychar1) for indexing tables with */

  if (yychar <= 0)		/* This means end of input. */
    {
      yychar1 = 0;
      yychar = YYEOF;		/* Don't call YYLEX any more */

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Now at end of input.\n");
#endif
    }
  else
    {
      yychar1 = YYTRANSLATE(yychar);

#if YYDEBUG != 0
      if (yydebug)
	{
	  fprintf (stderr, "Next token is %d (%s", yychar, yytname[yychar1]);
	  /* Give the individual parser a way to print the precise meaning
	     of a token, for further debugging info.  */
#ifdef YYPRINT
	  YYPRINT (stderr, yychar, yylval);
#endif
	  fprintf (stderr, ")\n");
	}
#endif
    }

  yyn += yychar1;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != yychar1)
    goto yydefault;

  yyn = yytable[yyn];

  /* yyn is what to do for this token type in this state.
     Negative => reduce, -yyn is rule number.
     Positive => shift, yyn is new state.
       New state is final state => don't bother to shift,
       just return success.
     0, or most negative number => error.  */

  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrlab;

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting token %d (%s), ", yychar, yytname[yychar1]);
#endif

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  /* count tokens shifted since error; after three, turn off error status.  */
  if (yyerrstatus) yyerrstatus--;

  yystate = yyn;
  goto yynewstate;

/* Do the default action for the current state.  */
yydefault:

  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;

/* Do a reduction.  yyn is the number of a rule to reduce with.  */
yyreduce:
  yylen = yyr2[yyn];
  if (yylen > 0)
    yyval = yyvsp[1-yylen]; /* implement default value of the action */

#if YYDEBUG != 0
  if (yydebug)
    {
      int i;

      fprintf (stderr, "Reducing via rule %d (line %d), ",
	       yyn, yyrline[yyn]);

      /* Print the symbols being reduced, and their result.  */
      for (i = yyprhs[yyn]; yyrhs[i] > 0; i++)
	fprintf (stderr, "%s ", yytname[yyrhs[i]]);
      fprintf (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif


  switch (yyn) {

case 1:
#line 145 "core/pbrtparse.y"
{
;
    break;}
case 2:
#line 149 "core/pbrtparse.y"
{
	if (cur_array) ArrayFree( cur_array );
	cur_array = new ParamArray;
	cur_array->allocated = 0;
	cur_array->nelems = 0;
	cur_array->array = NULL;
	array_is_single_string = false;
;
    break;}
case 3:
#line 159 "core/pbrtparse.y"
{
	cur_array->element_size = sizeof( const char * );
;
    break;}
case 4:
#line 164 "core/pbrtparse.y"
{
	cur_array->element_size = sizeof( float );
;
    break;}
case 5:
#line 169 "core/pbrtparse.y"
{
	yyval.ribarray = yyvsp[0].ribarray;
;
    break;}
case 6:
#line 173 "core/pbrtparse.y"
{
	yyval.ribarray = yyvsp[0].ribarray;
;
    break;}
case 7:
#line 178 "core/pbrtparse.y"
{
	yyval.ribarray = yyvsp[0].ribarray;
;
    break;}
case 8:
#line 182 "core/pbrtparse.y"
{
	yyval.ribarray = ArrayDup(cur_array);
	array_is_single_string = true;
;
    break;}
case 9:
#line 188 "core/pbrtparse.y"
{
	yyval.ribarray = ArrayDup(cur_array);
;
    break;}
case 10:
#line 193 "core/pbrtparse.y"
{
;
    break;}
case 11:
#line 197 "core/pbrtparse.y"
{
;
    break;}
case 12:
#line 200 "core/pbrtparse.y"
{
;
    break;}
case 13:
#line 204 "core/pbrtparse.y"
{
	char *to_add = strdup(yyvsp[0].string);
	AddArrayElement( &to_add );
;
    break;}
case 14:
#line 210 "core/pbrtparse.y"
{
	yyval.ribarray = yyvsp[0].ribarray;
;
    break;}
case 15:
#line 214 "core/pbrtparse.y"
{
	yyval.ribarray = ArrayDup(cur_array);
;
    break;}
case 16:
#line 219 "core/pbrtparse.y"
{
	yyval.ribarray = ArrayDup(cur_array);
;
    break;}
case 17:
#line 224 "core/pbrtparse.y"
{
;
    break;}
case 18:
#line 228 "core/pbrtparse.y"
{
;
    break;}
case 19:
#line 231 "core/pbrtparse.y"
{
;
    break;}
case 20:
#line 235 "core/pbrtparse.y"
{
	float to_add = yyvsp[0].num;
	AddArrayElement( &to_add );
;
    break;}
case 21:
#line 241 "core/pbrtparse.y"
{
;
    break;}
case 22:
#line 245 "core/pbrtparse.y"
{
	cur_paramlist_size = 0;
;
    break;}
case 23:
#line 250 "core/pbrtparse.y"
{
;
    break;}
case 24:
#line 253 "core/pbrtparse.y"
{
;
    break;}
case 25:
#line 257 "core/pbrtparse.y"
{
	void *arg = new char[ yyvsp[0].ribarray->nelems * yyvsp[0].ribarray->element_size ];
	memcpy(arg, yyvsp[0].ribarray->array, yyvsp[0].ribarray->nelems * yyvsp[0].ribarray->element_size);
	if (cur_paramlist_size >= cur_paramlist_allocated) {
		cur_paramlist_allocated = 2*cur_paramlist_allocated + 1;
		cur_paramlist_tokens = (const char **) realloc(cur_paramlist_tokens, cur_paramlist_allocated*sizeof(const char *) );
		cur_paramlist_args = (void * *) realloc( cur_paramlist_args, cur_paramlist_allocated*sizeof(void *) );
		cur_paramlist_sizes = (int *) realloc( cur_paramlist_sizes, cur_paramlist_allocated*sizeof(int) );
		cur_paramlist_texture_helper = (bool *) realloc( cur_paramlist_texture_helper, cur_paramlist_allocated*sizeof(bool) );
	}
	cur_paramlist_tokens[cur_paramlist_size] = yyvsp[-1].string;
	cur_paramlist_sizes[cur_paramlist_size] = yyvsp[0].ribarray->nelems;
	cur_paramlist_texture_helper[cur_paramlist_size] = array_is_single_string;
	cur_paramlist_args[cur_paramlist_size++] = arg;
	ArrayFree( yyvsp[0].ribarray );
;
    break;}
case 26:
#line 275 "core/pbrtparse.y"
{
;
    break;}
case 27:
#line 278 "core/pbrtparse.y"
{
;
    break;}
case 28:
#line 282 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtAccelerator(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 29:
#line 289 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtAreaLightSource(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 30:
#line 296 "core/pbrtparse.y"
{
	pbrtAttributeBegin();
;
    break;}
case 31:
#line 300 "core/pbrtparse.y"
{
	pbrtAttributeEnd();
;
    break;}
case 32:
#line 304 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtCamera(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 33:
#line 311 "core/pbrtparse.y"
{
	if (VerifyArrayLength( yyvsp[0].ribarray, 16, "ConcatTransform" ))
		pbrtConcatTransform( (float *) yyvsp[0].ribarray->array );
	ArrayFree( yyvsp[0].ribarray );
;
    break;}
case 34:
#line 317 "core/pbrtparse.y"
{
	pbrtCoordinateSystem( yyvsp[0].string );
;
    break;}
case 35:
#line 321 "core/pbrtparse.y"
{
	pbrtCoordSysTransform( yyvsp[0].string );
;
    break;}
case 36:
#line 325 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtFilm(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 37:
#line 332 "core/pbrtparse.y"
{
	pbrtIdentity();
;
    break;}
case 38:
#line 336 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtLightSource(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 39:
#line 343 "core/pbrtparse.y"
{
	pbrtLookAt(yyvsp[-8].num, yyvsp[-7].num, yyvsp[-6].num, yyvsp[-5].num, yyvsp[-4].num, yyvsp[-3].num, yyvsp[-2].num, yyvsp[-1].num, yyvsp[0].num);
;
    break;}
case 40:
#line 347 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtMaterial(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 41:
#line 354 "core/pbrtparse.y"
{
	pbrtObjectBegin(yyvsp[0].string);
;
    break;}
case 42:
#line 358 "core/pbrtparse.y"
{
	pbrtObjectEnd();
;
    break;}
case 43:
#line 362 "core/pbrtparse.y"
{
	pbrtObjectInstance(yyvsp[0].string);
;
    break;}
case 44:
#line 366 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtPixelFilter(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 45:
#line 373 "core/pbrtparse.y"
{
	pbrtReverseOrientation();
;
    break;}
case 46:
#line 377 "core/pbrtparse.y"
{
	pbrtRotate(yyvsp[-3].num, yyvsp[-2].num, yyvsp[-1].num, yyvsp[0].num);
;
    break;}
case 47:
#line 381 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtSampler(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 48:
#line 388 "core/pbrtparse.y"
{
	pbrtScale(yyvsp[-2].num, yyvsp[-1].num, yyvsp[0].num);
;
    break;}
case 49:
#line 392 "core/pbrtparse.y"
{
	pbrtSearchPath(yyvsp[0].string);
;
    break;}
case 50:
#line 396 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtShape(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 51:
#line 403 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtSurfaceIntegrator(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 52:
#line 410 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtTexture(yyvsp[-3].string, yyvsp[-2].string, yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 53:
#line 417 "core/pbrtparse.y"
{
	pbrtTransformBegin();
;
    break;}
case 54:
#line 421 "core/pbrtparse.y"
{
	pbrtTransformEnd();
;
    break;}
case 55:
#line 425 "core/pbrtparse.y"
{
	if (VerifyArrayLength( yyvsp[0].ribarray, 16, "Transform" ))
		pbrtTransform( (float *) yyvsp[0].ribarray->array );
	ArrayFree( yyvsp[0].ribarray );
;
    break;}
case 56:
#line 431 "core/pbrtparse.y"
{
	pbrtTranslate(yyvsp[-2].num, yyvsp[-1].num, yyvsp[0].num);
;
    break;}
case 57:
#line 435 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtVolumeIntegrator(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 58:
#line 442 "core/pbrtparse.y"
{
	ParamSet params;
	InitParamSet(params, CPS, CPT, CPA, CPSZ, CPTH);
	pbrtVolume(yyvsp[-1].string, params);
	FreeArgs();
;
    break;}
case 59:
#line 449 "core/pbrtparse.y"
{
	pbrtWorldBegin();
;
    break;}
case 60:
#line 453 "core/pbrtparse.y"
{
	pbrtWorldEnd();
;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */
#line 543 "/usr/share/bison.simple"

  yyvsp -= yylen;
  yyssp -= yylen;
#ifdef YYLSP_NEEDED
  yylsp -= yylen;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

  *++yyvsp = yyval;

#ifdef YYLSP_NEEDED
  yylsp++;
  if (yylen == 0)
    {
      yylsp->first_line = yylloc.first_line;
      yylsp->first_column = yylloc.first_column;
      yylsp->last_line = (yylsp-1)->last_line;
      yylsp->last_column = (yylsp-1)->last_column;
      yylsp->text = 0;
    }
  else
    {
      yylsp->last_line = (yylsp+yylen-1)->last_line;
      yylsp->last_column = (yylsp+yylen-1)->last_column;
    }
#endif

  /* Now "shift" the result of the reduction.
     Determine what state that goes to,
     based on the state we popped back to
     and the rule number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTBASE] + *yyssp;
  if (yystate >= 0 && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTBASE];

  goto yynewstate;

yyerrlab:   /* here on detecting error */

  if (! yyerrstatus)
    /* If not already recovering from an error, report this error.  */
    {
      ++yynerrs;

#ifdef YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  int size = 0;
	  char *msg;
	  int x, count;

	  count = 0;
	  /* Start X at -yyn if nec to avoid negative indexes in yycheck.  */
	  for (x = (yyn < 0 ? -yyn : 0);
	       x < (sizeof(yytname) / sizeof(char *)); x++)
	    if (yycheck[x + yyn] == x)
	      size += strlen(yytname[x]) + 15, count++;
	  msg = (char *) malloc(size + 15);
	  if (msg != 0)
	    {
	      strcpy(msg, "parse error");

	      if (count < 5)
		{
		  count = 0;
		  for (x = (yyn < 0 ? -yyn : 0);
		       x < (sizeof(yytname) / sizeof(char *)); x++)
		    if (yycheck[x + yyn] == x)
		      {
			strcat(msg, count == 0 ? ", expecting `" : " or `");
			strcat(msg, yytname[x]);
			strcat(msg, "'");
			count++;
		      }
		}
	      yyerror(msg);
	      free(msg);
	    }
	  else
	    yyerror ("parse error; also virtual memory exceeded");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror("parse error");
    }

  goto yyerrlab1;
yyerrlab1:   /* here on error raised explicitly by an action */

  if (yyerrstatus == 3)
    {
      /* if just tried and failed to reuse lookahead token after an error, discard it.  */

      /* return failure if at end of input */
      if (yychar == YYEOF)
	YYABORT;

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Discarding token %d (%s).\n", yychar, yytname[yychar1]);
#endif

      yychar = YYEMPTY;
    }

  /* Else will try to reuse lookahead token
     after shifting the error token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;

yyerrdefault:  /* current state does not do anything special for the error token. */

#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */
  yyn = yydefact[yystate];  /* If its default is to accept any token, ok.  Otherwise pop it.*/
  if (yyn) goto yydefault;
#endif

yyerrpop:   /* pop the current state because it cannot handle the error token */

  if (yyssp == yyss) YYABORT;
  yyvsp--;
  yystate = *--yyssp;
#ifdef YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "Error: state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

yyerrhandle:

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = yytable[yyn];
  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrpop;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrpop;

  if (yyn == YYFINAL)
    YYACCEPT;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting error token, ");
#endif

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  yystate = yyn;
  goto yynewstate;

 yyacceptlab:
  /* YYACCEPT comes here.  */
  if (yyfree_stacks)
    {
      free (yyss);
      free (yyvs);
#ifdef YYLSP_NEEDED
      free (yyls);
#endif
    }
  return 0;

 yyabortlab:
  /* YYABORT comes here.  */
  if (yyfree_stacks)
    {
      free (yyss);
      free (yyvs);
#ifdef YYLSP_NEEDED
      free (yyls);
#endif
    }
  return 1;
}
#line 456 "core/pbrtparse.y"

static void InitParamSet(ParamSet &ps, int count, const char **tokens,
		void **args, int *sizes, bool *texture_helper) {
	ps.Clear();
	for (int i = 0; i < count; ++i) {
		int type;
		string name;
		if (lookupType(tokens[i], &type, name)) {
			if (texture_helper && texture_helper[i] && type != PARAM_TYPE_TEXTURE && type != PARAM_TYPE_STRING)
			{
				Warning( "Bad type for %s. Changing it to a texture.", name.c_str());
				type = PARAM_TYPE_TEXTURE;
			}
			void *data = args[i];
			int nItems = sizes[i];
			if (type == PARAM_TYPE_INT) {
				// parser doesn't handle ints, so convert from floats here....
				int nAlloc = sizes[i];
				int *idata = new int[nAlloc];
				float *fdata = (float *)data;
				for (int j = 0; j < nAlloc; ++j)
					idata[j] = int(fdata[j]);
				ps.AddInt(name, idata, nItems);
				delete[] idata;
			}
			else if (type == PARAM_TYPE_BOOL) {
				// strings -> bools
				int nAlloc = sizes[i];
				bool *bdata = new bool[nAlloc];
				for (int j = 0; j < nAlloc; ++j) {
					string s(*((const char **)data));
					if (s == "true") bdata[j] = true;
					else if (s == "false") bdata[j] = false;
					else {
						Warning("Value \"%s\" unknown for boolean parameter \"%s\"."
							"Using \"false\".", s.c_str(), tokens[i]);
						bdata[j] = false;
					}
				}
				ps.AddBool(name, bdata, nItems);
				delete[] bdata;
			}
			else if (type == PARAM_TYPE_FLOAT) {
				ps.AddFloat(name, (float *)data, nItems);
			} else if (type == PARAM_TYPE_POINT) {
				ps.AddPoint(name, (Point *)data, nItems / 3);
			} else if (type == PARAM_TYPE_VECTOR) {
				ps.AddVector(name, (Vector *)data, nItems / 3);
			} else if (type == PARAM_TYPE_NORMAL) {
				ps.AddNormal(name, (Normal *)data, nItems / 3);
			} else if (type == PARAM_TYPE_COLOR) {
				ps.AddSpectrum(name, (Spectrum *)data, nItems / COLOR_SAMPLES);
			} else if (type == PARAM_TYPE_STRING) {
				string *strings = new string[nItems];
				for (int j = 0; j < nItems; ++j)
					strings[j] = string(*((const char **)data+j));
				ps.AddString(name, strings, nItems);
				delete[] strings;
			}
			else if (type == PARAM_TYPE_TEXTURE) {
				if (nItems == 1) {
					string val(*((const char **)data));
					ps.AddTexture(name, val);
				}
				else
					Error("Only one string allowed for \"texture\" parameter \"%s\"",
						name.c_str());
			}
		}
		else
			Warning("Type of parameter \"%s\" is unknown",
				tokens[i]);
	}
}
static bool lookupType(const char *token, int *type, string &name) {
	Assert(token != NULL);
	*type = 0;
	const char *strp = token;
	while (*strp && isspace(*strp))
		++strp;
	if (!*strp) {
		Error("Parameter \"%s\" doesn't have a type declaration?!", token);
		return false;
	}
	#define TRY_DECODING_TYPE(name, mask) \
		if (strncmp(name, strp, strlen(name)) == 0) { \
			*type = mask; strp += strlen(name); \
		}
	     TRY_DECODING_TYPE("float",    PARAM_TYPE_FLOAT)
	else TRY_DECODING_TYPE("integer",  PARAM_TYPE_INT)
	else TRY_DECODING_TYPE("bool",     PARAM_TYPE_BOOL)
	else TRY_DECODING_TYPE("point",    PARAM_TYPE_POINT)
	else TRY_DECODING_TYPE("vector",   PARAM_TYPE_VECTOR)
	else TRY_DECODING_TYPE("normal",   PARAM_TYPE_NORMAL)
	else TRY_DECODING_TYPE("string",   PARAM_TYPE_STRING)
	else TRY_DECODING_TYPE("texture",  PARAM_TYPE_TEXTURE)
	else TRY_DECODING_TYPE("color",    PARAM_TYPE_COLOR)
	else {
		Error("Unable to decode type for token \"%s\"", token);
		return false;
	}
	while (*strp && isspace(*strp))
		++strp;
	name = string(strp);
	return true;
}
