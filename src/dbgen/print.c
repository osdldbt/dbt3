/*
* $Id: print.c,v 1.3 2005/10/28 02:56:22 jms Exp $
*
* Revision History
* ===================
* $Log: print.c,v $
* Revision 1.3  2005/10/28 02:56:22  jms
* add platform-specific printf formats to allow for DSS_HUGE data type
*
* Revision 1.2  2005/01/03 20:08:59  jms
* change line terminations
*
* Revision 1.1.1.1  2004/11/24 23:31:47  jms
* re-establish external server
*
* Revision 1.4  2004/02/18 16:26:49  jms
* 32/64 bit changes for overflow handling needed additional changes when ported back to windows
*
* Revision 1.3  2004/02/18 14:05:53  jms
* porting changes for LINUX and 64 bit RNG
*
* Revision 1.2  2004/01/22 05:49:29  jms
* AIX porting (AIX 5.1)
*
* Revision 1.1.1.1  2003/08/07 17:58:34  jms
* recreation after CVS crash
*
* Revision 1.2  2003/08/07 17:58:34  jms
* Convery RNG to 64bit space as preparation for new large scale RNG
*
* Revision 1.1.1.1  2003/04/03 18:54:21  jms
* initial checkin
*
*
*/
/* generate flat files for data load */
#include <stdio.h>
#ifndef VMS
#include <sys/types.h>
#endif
#if defined(SUN)
#include <unistd.h>
#endif
#include <math.h>

#include "dss.h"
#include "dsstypes.h"
#include <string.h>

/*
 * Function Prototypes
 */
FILE *print_prep PROTO((int table, int update));
int pr_drange PROTO((int tbl, DSS_HUGE min, DSS_HUGE cnt, long num));

FILE *
print_prep(int table, int update)
{
	char upath[128];
	FILE *res;

	if (updates)
		{
		if (update > 0) /* updates */
			if ( insert_segments )
				{
				int this_segment;
				if(strcmp(tdefs[table].name,"orders.tbl"))
					this_segment=++insert_orders_segment;
				else 
					this_segment=++insert_lineitem_segment;
				sprintf(upath, "%s%c%s.u%d.%d", 
					env_config(PATH_TAG, PATH_DFLT),
					PATH_SEP, tdefs[table].name, update%10000,this_segment);
				}
			else
				{
				sprintf(upath, "%s%c%s.u%d",
				env_config(PATH_TAG, PATH_DFLT),
				PATH_SEP, tdefs[table].name, update);
				}
		else /* deletes */
			if ( delete_segments )
				{
				++delete_segment;
				sprintf(upath, "%s%cdelete.u%d.%d",
					env_config(PATH_TAG, PATH_DFLT), PATH_SEP, -update%10000,
					delete_segment);
				}
			else
				{
				sprintf(upath, "%s%cdelete.%d",
				env_config(PATH_TAG, PATH_DFLT), PATH_SEP, -update);
				}
		return(fopen(upath, "w"));
        }
    res = tbl_open(table, "w");
    OPEN_CHECK(res, tdefs[table].name);
    return(res);
}

/*
 * pg_inttostr
 *		Converts 'value' into a decimal string representation of the number.
 *
 * Caller must ensure that 'str' points to enough memory to hold the result
 * (at least 12 bytes, counting a leading sign and trailing NUL). The return
 * value is a pointer to, would be end of string. Note that the NUL termination
 * char is not written.
 *
 * The intended use pattern for this function is to build strings which contain
 * multiple individual numbers, such as:
 *
 *	str = pg_inttostr(str, a);
 *	*str++ = ' ';
 *	str = pg_inttostr(str, b);
 *	*str = '\0';
 *
 * Note: Caller must ensure that 'a' points to enough memory to hold the result
 * (at least 12 bytes, counting a leading sign and trailing NUL).
 */
char *
pg_inttostr(char *str, long value)
{
	char *start;
	char *end;

	/*
	 * Handle negative numbers in a special way. We can't just append a '-'
	 * prefix and reverse the sign as on two's complement machines negative
	 * numbers can be 1 further from 0 than positive numbers, we do it this way
	 * so we properly handle the smallest possible value.
	 */
	if (value < 0)
	{
		*str++ = '-';

		/* mark the position we must reverse the string from. */
		start = str;

		/* Compute the result string backwards. */
		do
		{
			long		remainder;
			long		oldval = value;

			value /= 10;
			remainder = oldval - value * 10;
			*str++ = '0' + -remainder;
		} while (value != 0);
	}
	else
	{
		/* mark the position we must reverse the string from. */
		start = str;
		do
		{
			long		remainder;
			long		oldval = value;

			value /= 10;
			remainder = oldval - value * 10;
			*str++ = '0' + remainder;
		} while (value != 0);
	}

	/* Remember the end of string and back up 'str' to the last character. */
	end = str--;

	/* Reverse string. */
	while (start < str)
	{
		char		swap = *start;
		*start++ = *str;
		*str-- = swap;
	}
	return end;
}

/*
 * pg_inttostr_zeropad
 *		Converts 'value' into a decimal string representation of the number.
 *		'padding' specifies the minimum width of the number. Any extra space
 *		is filled up by prefixing the number with zeros. The return value is a
 *		pointer to, would be end of string. Note that the NUL termination char
 *		is not written.
 *
 * The intended use pattern for this function is to build strings which contain
 * multiple individual numbers, such as:
 *
 *	str = pg_inttostr_zeropad(str, hours, 2);
 *	*str++ = ':';
 *	str = pg_inttostr_zeropad(str, mins, 2);
 *	*str++ = ':';
 *	str = pg_inttostr_zeropad(str, secs, 2);
 *	*str = '\0';
 *
 * Note: Callers should ensure that 'padding' is above zero.
 * Note: This function is optimized for the case where the number is not too
 *		 big to fit inside of the specified padding.
 * Note: Caller must ensure that 'str' points to enough memory to hold the
		 result (at least 12 bytes, counting a leading sign and trailing NUL,
		 or padding + 1 bytes, whichever is larger).
 */
char *
pg_inttostr_zeropad(char *str, long value, long padding)
{
	char	   *start = str;
	char	   *end = &str[padding];
	long		num = value;

	/*
	 * Handle negative numbers in a special way. We can't just append a '-'
	 * prefix and reverse the sign as on two's complement machines negative
	 * numbers can be 1 further from 0 than positive numbers, we do it this way
	 * so we properly handle the smallest possible value.
	 */
	if (num < 0)
	{
		*start++ = '-';
		padding--;

		/*
		 * Build the number starting at the end. Here remainder will be a
		 * negative number, we must reverse this sign on this before adding
		 * '0' in order to get the correct ASCII digit
		 */
		while (padding--)
		{
			long		remainder;
			long		oldval = num;

			num /= 10;
			remainder = oldval - num * 10;
			start[padding] = '0' + -remainder;
		}
	}
	else
	{
		/* build the number starting at the end */
		while (padding--)
		{
			long		remainder;
			long		oldval = num;

			num /= 10;
			remainder = oldval - num * 10;
			start[padding] = '0' + remainder;
		}
	}

	/*
	 * If padding was not high enough to fit this number then num won't have
	 * been divided down to zero. We'd better have another go, this time we
	 * know there won't be any zero padding required so we can just enlist the
	 * help of pg_int2str()
	 */
	if (num != 0)
		return pg_inttostr(str, value);

	return end; /* Not NUL terminated */
}

char *
pg_int64tostr(char *str, DSS_HUGE value)
{
	char *start;
	char *end;

	/*
	 * Handle negative numbers in a special way. We can't just append a '-'
	 * prefix and reverse the sign as on two's complement machines negative
	 * numbers can be 1 further from 0 than positive numbers, we do it this way
	 * so we properly handle the smallest possible value.
	 */
	if (value < 0)
	{
		*str++ = '-';

		/* mark the position we must reverse the string from. */
		start = str;

		/* Compute the result string backwards. */
		do
		{
			DSS_HUGE		remainder;
			DSS_HUGE		oldval = value;

			value /= 10;
			remainder = oldval - value * 10;
			*str++ = '0' + -remainder;
		} while (value != 0);
	}
	else
	{
		/* mark the position we must reverse the string from. */
		start = str;
		do
		{
			DSS_HUGE		remainder;
			DSS_HUGE		oldval = value;

			value /= 10;
			remainder = oldval - value * 10;
			*str++ = '0' + remainder;
		} while (value != 0);
	}

	/* Remember the end of string and back up 'str' to the last character. */
	end = str--;

	/* Reverse string. */
	while (start < str)
	{
		char		swap = *start;
		*start++ = *str;
		*str-- = swap;
	}
	return end;
}

int
dbg_print(int format, FILE *target, void *data, int len, int sep)
{
	int dollars,
		cents;
	char buffer[30];
	char *p;

	switch(format)
	{
	case DT_STR:
		fputs(data, target);
		break;
#ifdef MVS
	case DT_VSTR:
		/* note: only used in MVS, assumes columnar output */
		fprintf(target, "%c%c%-*s", 
			(len >> 8) & 0xFF, len & 0xFF, len, (char *)data);
		break;
#endif /* MVS */
	case DT_INT:
		p = pg_inttostr(buffer, (long)data);
		fwrite(buffer, 1, p - buffer, target);
		break;
	case DT_HUGE:
		p = pg_int64tostr(buffer, *(DSS_HUGE *)data);
		fwrite(buffer, 1, p - buffer, target);
		break;
	case DT_KEY:
		p = pg_inttostr(buffer, (long)data);
		fwrite(buffer, 1, p - buffer, target);
		break;
	case DT_MONEY:
		cents = (int)*(DSS_HUGE *)data;
		if (cents < 0)
			{
			fprintf(target, "-");
			cents = -cents;
			}
		dollars = cents / 100;
		cents %= 100;
#ifdef PGSQL
		p = pg_inttostr(buffer, dollars);
		*p++ = '.';
		p = pg_inttostr_zeropad(p, cents, 2);
		fwrite(buffer, 1, p - buffer, target);
#else
		fprintf(target, "%d.%02d", dollars, cents);
#endif /* PGSQL */
		break;
	case DT_CHR:
#ifdef PGSQL
		fputc(*(char *)data, target);
#else
		fprintf(target, "%c", *(char *)data);
#endif /* PGSQL */
		break;
	}

#ifdef EOL_HANDLING
	if (sep)
#endif /* EOL_HANDLING */
#ifdef PGSQL
	fputc(SEPARATOR, target);
#else
	fprintf(target, "%c", (char) SEPARATOR);
#endif
	
	return(0);
}

int
pr_cust(customer_t *c, int mode)
{
static FILE *fp = NULL;
        
   if (fp == NULL)
        fp = print_prep(CUST, 0);

   PR_STRT(fp);
   PR_HUGE(fp, &c->custkey, 1);
   if (scale <= 3000)
   PR_VSTR(fp, c->name, C_NAME_LEN, 1);
   else
   PR_VSTR(fp, c->name, C_NAME_LEN + 3, 1);
   PR_VSTR(fp, c->address, c->alen, 1);
   PR_HUGE(fp, &c->nation_code, 1);
   PR_STR(fp, c->phone, PHONE_LEN, 1);
   PR_MONEY(fp, &c->acctbal, 1);
   PR_STR(fp, c->mktsegment, C_MSEG_LEN, 1);
   PR_VSTR_LAST(fp, c->comment, c->clen);
   PR_END(fp);

   return(0);
}

/*
 * print the numbered order 
 */
int
pr_order(order_t *o, int mode)
{
    static FILE *fp_o = NULL;
    static int last_mode = 0;
        
    if (fp_o == NULL || mode != last_mode)
        {
        if (fp_o) 
            fclose(fp_o);
        fp_o = print_prep(ORDER, mode);
        last_mode = mode;
        }
    PR_STRT(fp_o);
    PR_HUGE(fp_o, &o->okey, 1);
    PR_HUGE(fp_o, &o->custkey, 1);
    PR_CHR(fp_o, &o->orderstatus, 1);
    PR_MONEY(fp_o, &o->totalprice, 1);
    PR_STR(fp_o, o->odate, DATE_LEN, 1);
    PR_STR(fp_o, o->opriority, O_OPRIO_LEN, 1);
    PR_STR(fp_o, o->clerk, O_CLRK_LEN, 1);
    PR_INT(fp_o, o->spriority, 1);
    PR_VSTR_LAST(fp_o, o->comment, o->clen);
    PR_END(fp_o);

    return(0);
}

/*
 * print an order's lineitems
 */
int
pr_line(order_t *o, int mode)
{
    static FILE *fp_l = NULL;
    static int last_mode = 0;
    long      i;
        
    if (fp_l == NULL || mode != last_mode)
        {
        if (fp_l) 
            fclose(fp_l);
        fp_l = print_prep(LINE, mode);
        last_mode = mode;
        }

    for (i = 0; i < o->lines; i++)
        {
        PR_STRT(fp_l);
        PR_HUGE(fp_l, &o->l[i].okey, 1);
        PR_HUGE(fp_l, &o->l[i].partkey, 1);
        PR_HUGE(fp_l, &o->l[i].suppkey, 1);
        PR_HUGE(fp_l, &o->l[i].lcnt, 1);
        PR_HUGE(fp_l, &o->l[i].quantity, 1);
        PR_MONEY(fp_l, &o->l[i].eprice, 1);
        PR_MONEY(fp_l, &o->l[i].discount, 1);
        PR_MONEY(fp_l, &o->l[i].tax, 1);
        PR_CHR(fp_l, &o->l[i].rflag[0], 1);
        PR_CHR(fp_l, &o->l[i].lstatus[0], 1);
        PR_STR(fp_l, o->l[i].sdate, DATE_LEN, 1);
        PR_STR(fp_l, o->l[i].cdate, DATE_LEN, 1);
        PR_STR(fp_l, o->l[i].rdate, DATE_LEN, 1);
        PR_STR(fp_l, o->l[i].shipinstruct, L_INST_LEN, 1);
        PR_STR(fp_l, o->l[i].shipmode, L_SMODE_LEN, 1);
        PR_VSTR_LAST(fp_l, o->l[i].comment,o->l[i].clen);
        PR_END(fp_l);
        }

   return(0);
}

/*
 * print the numbered order *and* its associated lineitems
 */
int
pr_order_line(order_t *o, int mode)
{
    tdefs[ORDER].name = tdefs[ORDER_LINE].name;
    pr_order(o, mode);
    pr_line(o, mode);

    return(0);
}

/*
 * print the given part
 */
int
pr_part(part_t *part, int mode)
{
static FILE *p_fp = NULL;

    if (p_fp == NULL)
        p_fp = print_prep(PART, 0);

   PR_STRT(p_fp);
   PR_HUGE(p_fp, &part->partkey, 1);
   PR_VSTR(p_fp, part->name,part->nlen, 1);
   PR_STR(p_fp, part->mfgr, P_MFG_LEN, 1);
   PR_STR(p_fp, part->brand, P_BRND_LEN, 1);
   PR_VSTR(p_fp, part->type,part->tlen, 1);
   PR_HUGE(p_fp, &part->size, 1);
   PR_STR(p_fp, part->container, P_CNTR_LEN, 1);
   PR_MONEY(p_fp, &part->retailprice, 1);
   PR_VSTR_LAST(p_fp, part->comment,part->clen);
   PR_END(p_fp);

   return(0);
}

/*
 * print the given part's suppliers
 */
int
pr_psupp(part_t *part, int mode)
{
    static FILE *ps_fp = NULL;
    long      i;

    if (ps_fp == NULL)
        ps_fp = print_prep(PSUPP, mode);

   for (i = 0; i < SUPP_PER_PART; i++)
      {
      PR_STRT(ps_fp);
      PR_HUGE(ps_fp, &part->s[i].partkey, 1);
      PR_HUGE(ps_fp, &part->s[i].suppkey, 1);
      PR_HUGE(ps_fp, &part->s[i].qty, 1);
      PR_MONEY(ps_fp, &part->s[i].scost, 1);
      PR_VSTR_LAST(ps_fp, part->s[i].comment,part->s[i].clen);
      PR_END(ps_fp);
      }

   return(0);
}

/*
 * print the given part *and* its suppliers
 */
int
pr_part_psupp(part_t *part, int mode)
{
    tdefs[PART].name = tdefs[PART_PSUPP].name;
    pr_part(part, mode);
    pr_psupp(part, mode);

    return(0);
}

int
pr_supp(supplier_t *supp, int mode)
{
static FILE *fp = NULL;
        
   if (fp == NULL)
        fp = print_prep(SUPP, mode);

   PR_STRT(fp);
   PR_HUGE(fp, &supp->suppkey, 1);
   PR_STR(fp, supp->name, S_NAME_LEN, 1);
   PR_VSTR(fp, supp->address, supp->alen, 1);
   PR_HUGE(fp, &supp->nation_code, 1);
   PR_STR(fp, supp->phone, PHONE_LEN, 1);
   PR_MONEY(fp, &supp->acctbal, 1);
   PR_VSTR_LAST(fp, supp->comment, supp->clen);
   PR_END(fp);

   return(0);
}

int
pr_nation(code_t *c, int mode)
{
static FILE *fp = NULL;
        
   if (fp == NULL)
        fp = print_prep(NATION, mode);

   PR_STRT(fp);
   PR_HUGE(fp, &c->code, 1);
   PR_STR(fp, c->text, NATION_LEN, 1);
   PR_INT(fp, c->join, 1);
   PR_VSTR_LAST(fp, c->comment, c->clen);
   PR_END(fp);

   return(0);
}

int
pr_region(code_t *c, int mode)
{
static FILE *fp = NULL;
        
   if (fp == NULL)
        fp = print_prep(REGION, mode);

   PR_STRT(fp);
   PR_HUGE(fp, &c->code, 1);
   PR_STR(fp, c->text, REGION_LEN, 1);
   PR_VSTR_LAST(fp, c->comment, c->clen);
   PR_END(fp);

   return(0);
}

/* 
 * NOTE: this routine does NOT use the BCD2_* routines. As a result,
 * it WILL fail if the keys being deleted exceed 32 bits. Since this
 * would require ~660 update iterations, this seems an acceptable
 * oversight
 */
int
pr_drange(int tbl, DSS_HUGE min, DSS_HUGE cnt, long num)
{
    static int  last_num = 0;
    static FILE *dfp = NULL;
    DSS_HUGE child = -1;
    DSS_HUGE start, last, new;

	static DSS_HUGE rows_per_segment=0;
	static DSS_HUGE rows_this_segment=0;

    if (last_num != num)
        {
        if (dfp)
            fclose(dfp);
        dfp = print_prep(tbl, -num);
        if (dfp == NULL)
            return(-1);
        last_num = num;
		rows_this_segment=0;
        }

    start = MK_SPARSE(min, num/ (10000 / UPD_PCT));
    last = start - 1;
    for (child=min; cnt > 0; child++, cnt--)
	{
		new = MK_SPARSE(child, num/ (10000 / UPD_PCT));
		if (delete_segments)
		{

			if(rows_per_segment==0) 
				rows_per_segment = (cnt / delete_segments) + 1;
			if((++rows_this_segment) > rows_per_segment)
			{
				fclose(dfp);
				dfp = print_prep(tbl, -num);
				if (dfp == NULL) return(-1);
				last_num = num;
				rows_this_segment=1;
			}
		}
		PR_STRT(dfp);
#ifdef PGSQL
		PR_HUGE(dfp, &new,0);
#else
		PR_HUGE_LAST(dfp, &new);
#endif /* PGSQL */
		PR_END(dfp);
		start = new;
		last = new;
	}
    
    return(0);
}



